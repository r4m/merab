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
 * Configuration file of the module SensorP.nc
 *
 * @date 25/05/2011 14:50
 * @author Filippo Zanella <filippo.zanella@dei.unipd.it>
 */

#include <Timer.h>
#include <UserButton.h>
#include "../TmoteComm.h"

configuration SensorC
{}
implementation
{  
	components MainC, LedsC;
	components SensorP as App;
	components new TimerMilliC() as SamplingClock;

	components new DemoSensorC() as VoltSensor;
	components new SensirionSht11C() as TempHumiSensor;
	components new HamamatsuS1087ParC() as PARSensor;
	components new HamamatsuS10871TsrC() as TSRSensor;

	components SerialActiveMessageC as SAM;

	components UserButtonC;

	App.Boot           -> MainC.Boot;
	App.Leds           -> LedsC.Leds;
	App.SamplingClock -> SamplingClock.Timer;

	App.Voltage -> VoltSensor;
	App.Temperature -> TempHumiSensor.Temperature;
	App.Humidity -> TempHumiSensor.Humidity;
	App.PAR -> PARSensor;
	App.TSR -> TSRSensor;

	App.AMCtrlSerial -> SAM;
	App.AMSendToSerial -> SAM.AMSend[AM_DATA_SENSORS_MSG];
	App.Packet -> SAM;

	App.GetBS          -> UserButtonC.Get;
	App.NotifyBS       -> UserButtonC.Notify;
}
