void setup() {
  // put your s  etup code here, to run once:

  Serial.begin(115200);

  pinMode(12,OUTPUT);
  pinMode(25,OUTPUT);
  pinMode(17, OUTPUT);
  pinMode(39, INPUT_PULLUP);
  pinMode(26, INPUT_PULLUP);


}

void loop() {
  // put your main code here, to run repeatedly:
  //26 bth 16 pwr
  int state= digitalRead(26);

  digitalWrite(12,HIGH);
  digitalWrite(25,HIGH);
  digitalWrite(17,HIGH);   

  Serial.println(state);
  delay(1000);


}
