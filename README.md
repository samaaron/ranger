# Ranger

Communicate with an ultrasonic rangefinder to assertain the distance of objects from it.

## Dependencies

* An [ultrasonic rangefinder](http://www.robot-electronics.co.uk/htm/srf04tech.htm)
* An [Arduino](http://arduino.cc)

## Setup

Connect the following Rangefinder connections to the specified Arduino connections:

* Rangerfinder 5V -> Arduino 5V
* Rangefinder Echo Pulse Output -> Arduino Digital 2
* Rangefinder Trigger Pulse Input -> Arduino Digital 3
* Rangefinder Do Not Connect -> Arduino Ground
* Rangefinder Ground -> Arduino Ground

## Use

The Arduino will continually send individual bytes (integers in the range 0 -> 255) to the serial port representing the distance of the object from the sensor.
