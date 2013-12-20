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
 * Header file.
 *
 * @date 25/05/2011 14:50
 * @author Filippo Zanella <filippo.zanella@dei.unipd.it>
 */ 

#ifndef TMOTE_COMM_H
#define TMOTE_COMM_H

enum
{
  SAMPLING_FREQUENCY =  1000, 	  //[ms] Sampling time
  AM_DATA_SENSORS_MSG = 0x90,	  // AM of the serial protocol
};

typedef nx_struct data_sensors_msg 
{
  nx_uint8_t id;         // ID of the sensor
  nx_uint16_t counter;       // ID of the received packet [n-th]
  //nx_uint16_t voltage;       // [RAW] Voltage
  nx_uint16_t temperature;   // [RAW] Temperature 
  nx_uint16_t humidity;      // [RAW] Humidity 
  nx_uint16_t par;         // [RAW] PAR
  nx_uint16_t tsr;         // [RAW] TSR
} data_sensors_msg_t;

#endif
