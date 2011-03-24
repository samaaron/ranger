#define echoPin 2                            // Pin to receive echo pulse YELLOW
#define trigPin 3                            // Pin to send trigger pulse GREEN

unsigned long d = 0;

//rangefinder
unsigned long distance = 0;
unsigned long MAX_RANGE = 10200;
unsigned long MIN_RANGE = 150;


//interval
unsigned long interval = 20;
unsigned long previous_time = 0;
unsigned long now = 0;

void setup(){
  Serial.begin(115200);
  pinMode(echoPin, INPUT);
  pinMode(trigPin, OUTPUT);
}

int raw_rangefinder_distance(){
  unsigned long incoming_distance;
  digitalWrite(trigPin, LOW);                   // Set the trigger pin to low for 2uS
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);                  // Send a 10uS high to trigger ranging
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);                   // Send pin low again
  incoming_distance = pulseIn(echoPin, HIGH);   // Read in times pulse
  delay(3);
  if (incoming_distance < 1) incoming_distance = 0;
  return incoming_distance;
}

//http://stackoverflow.com/questions/5294955/how-to-scale-down-a-range-of-numbers-with-a-known-min-and-max-value
int scale255(unsigned long val){
  //scales an input value with the specified range to an integer between 0 and 255

  unsigned long scaled = ((255 * (val - MIN_RANGE)) / (MAX_RANGE - MIN_RANGE));

  if(scaled > 255) {return 255;}
  if(scaled < 0) {return 0;}
  return int(scaled);
}


unsigned long read_rangefinder() {
  unsigned long d1 = raw_rangefinder_distance();
  if(d1 > 100000000) return MIN_RANGE;
  unsigned long d2 = raw_rangefinder_distance();
  if(d2 > 100000000) return MIN_RANGE;
  unsigned long d3 = raw_rangefinder_distance();
  if(d3 > 100000000) return MIN_RANGE;
  unsigned long d4 = raw_rangefinder_distance();
  if(d4 > 100000000) return MIN_RANGE;
  unsigned long d5 = raw_rangefinder_distance();
  if(d5 > 100000000) return MIN_RANGE;

  unsigned long num = 5;
  unsigned long result = (d1 + d2 + d3 + d4 + d5) / num;

  return result;
}

void each_interval() {
  distance = read_rangefinder();
  Serial.write(scale255(distance));

}

void loop(){
  now = millis();
  if((now - previous_time) > interval) {
    previous_time = now;
    each_interval();
  }
}

