#define echoPin 2                            // Pin to receive echo pulse YELLOW
#define trigPin 3                            // Pin to send trigger pulse GREEN

//rangefinder
unsigned long distance = 0;
unsigned long MAX_RANGE = 10200;
unsigned long MIN_RANGE = 150;
unsigned long OUT_OF_BOUNDS = 100000000;

//interval
unsigned long interval = 20;
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
//scales an input value with the specified range to an integer between 0 and 255
int scale255(unsigned long val){


  unsigned long scaled = ((255 * (val - MIN_RANGE)) / (MAX_RANGE - MIN_RANGE));

  if(scaled > 255) {return 255;}
  if(scaled < 0) {return 0;}
  return int(scaled);
}


// grab 5 consecutive values and average them
// shortcircuit if the returned value is out of
// bounds as that seems to represent an object
// being too close.
unsigned long read_rangefinder() {

  unsigned long d1 = raw_rangefinder_distance();
  if(d1 > OUT_OF_BOUNDS) return MIN_RANGE;
  unsigned long d2 = raw_rangefinder_distance();
  if(d2 > OUT_OF_BOUNDS) return MIN_RANGE;
  unsigned long d3 = raw_rangefinder_distance();
  if(d3 > OUT_OF_BOUNDS) return MIN_RANGE;
  unsigned long d4 = raw_rangefinder_distance();
  if(d4 > OUT_OF_BOUNDS) return MIN_RANGE;
  unsigned long d5 = raw_rangefinder_distance();
  if(d5 > OUT_OF_BOUNDS) return MIN_RANGE;

  unsigned long num = 5;
  unsigned long result = (d1 + d2 + d3 + d4 + d5) / num;

  return result;
}

//called during each interval of `interval` ms
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

