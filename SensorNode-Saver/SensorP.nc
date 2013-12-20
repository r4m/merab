/*
 * Copyright (c) 2010, Department of Information Engineering, University of Padova.
 * All rights reserved.
 *
 * This file is part of Merab.
 *
 * Merab is free software: you can redistribute it and/or modify it under the terms
 * of the GNU General Public License as published by the Free Software Foundation,
 * either version 3 of the License, or (at your option) any later version.
 *
 * Merab is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
 * without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
 * PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Merab.  If not, see <http://www.gnu.org/licenses/>.
 *
 * ===================================================================================
 */

/**
 *
 * This is the application of the sensor measurements acquisition
 *
 * @date 25/05/2011 14:50
 * @author Filippo Zanella <filippo.zanella@dei.unipd.it>
 */

module SensorP
{
	uses
	{  
		interface Leds;
		interface Boot;
		interface Timer<TMilli> as SamplingClock;

		interface Packet;
		
		interface SplitControl as AMCtrlSerial;
		interface AMSend as AMSendToSerial;

		interface Read<uint16_t> as Voltage;
		interface Read<uint16_t> as Temperature;
		interface Read<uint16_t> as Humidity;
		interface Read<uint16_t> as PAR;
		interface Read<uint16_t> as TSR;

		interface Get<button_state_t> as GetBS;
		interface Notify<button_state_t> as NotifyBS;
	}
}


implementation
{
	message_t packet;										
	bool lockedSerial;										
	bool startAcquisition;									

	data_sensors_msg_t dsm;									

	task void sendSerialMsg();


	/******************************* Init *****************************/

	event void Boot.booted() {

		startAcquisition = FALSE;

        dsm.counter = 0;
		call Leds.set(000);
		call NotifyBS.enable();
		call AMCtrlSerial.start();
	}

	event void AMCtrlSerial.startDone(error_t error) {
		if (error == SUCCESS) {
		}
		else
			call AMCtrlSerial.start();
	}

	event void AMCtrlSerial.stopDone(error_t error) {}


	/******************************* Sensors *****************************/
	event void SamplingClock.fired() {
		call Leds.led2Toggle();

		call Voltage.read();
		call Temperature.read();
		call Humidity.read();
		call PAR.read();
		call TSR.read();
		
		dsm.counter = dsm.counter +1;
	}

	event void Voltage.readDone(error_t result, uint16_t data) {
		if (result == SUCCESS) {
			dsm.voltage = data;
		}
		else
			dsm.voltage = 0xFFFF;
	}

	event void Temperature.readDone(error_t result, uint16_t data) {
		if (result == SUCCESS) {
			dsm.temperature = data;
		}
		else
			dsm.temperature = 0xFFFF;
	}

	event void Humidity.readDone(error_t result, uint16_t data) {
		if (result == SUCCESS) {
			dsm.humidity = data;
		}
		else
			dsm.humidity = 0xFFFF;
	}

	event void PAR.readDone(error_t result, uint16_t data) {
		if (result == SUCCESS) {
			dsm.par = data;
		}
		else
			dsm.par = 0xFFFF;

		post sendSerialMsg();
	}

	event void TSR.readDone(error_t result, uint16_t data) {
		if (result == SUCCESS) {
			dsm.tsr = data;
		}
		else
			dsm.tsr = 0xFFFF;

		post sendSerialMsg();
	}


	/*************************** User Button *****************************/

	event void NotifyBS.notify(button_state_t state) {
		if (state == BUTTON_PRESSED) {
			if(startAcquisition == FALSE) {
				startAcquisition = TRUE;
				call SamplingClock.startPeriodic(SAMPLING_FREQUENCY);
			}
			else {
				startAcquisition = FALSE;
				call SamplingClock.stop();
			}
		}
	}


	/******************************* Serial *****************************/

	task void sendSerialMsg() {
		if(lockedSerial){}
		else {
			data_sensors_msg_t toSend = dsm;
			data_sensors_msg_t *rsm = (data_sensors_msg_t*)call Packet.getPayload(&packet, sizeof(data_sensors_msg_t));
      		if (rsm == NULL) {return;}
      		
			atomic
			{
				rsm->id  = toSend.id;
				rsm->counter = toSend.counter;
				//rsm->voltage    = toSend.voltage;
				rsm->temperature     = toSend.temperature;
				rsm->humidity     = toSend.humidity;
				rsm->par = toSend.par;
				rsm->tsr = toSend.tsr;
			}
			
			if (call AMSendToSerial.send(AM_BROADCAST_ADDR, &packet, sizeof(data_sensors_msg_t)) == SUCCESS) {
				lockedSerial = TRUE;
			}
		}
	}

	event void AMSendToSerial.sendDone(message_t* msg, error_t error) {
		if (&packet == msg) {
			lockedSerial = FALSE;
			call Leds.led0Toggle();
		}
	}
}
