# Adaptive-Cruise-Control
+ Note:
+ This is a self-study project to improve C programming skills and AVR microcontroller knowledge.
+ Tools: Proteus, Codevision
+ Tasks: Simulate circuit diagram on Proteus, build code in Codevision and load hex file to AVR microcontroller, test system and debug,...
+ Knowledge used in this project:
  - Microcontroller: 
  - C language: 
  - Automotive:
+ Working principle: 
  - Normal mode: increase/decrease speed depending on accelerator and brake pedals.
  - Cruise Control mode: The speed is set by the Set button, after the speed has been set, it can be changed by the (+)/(-) button. If the Cancel button is pressed or     the brake pedal is pressed, the system will temporarily rotate to normal operation, press the Res button to return the vehicle to the previously set speed.
  - Adaptive Cruise Control mode: This mode can only be activated when Cruise Control is active and speed is set. This mode has 2 states: the distance to the car in       front is less than 100m and the distance to the car in front is over 100m (assuming the road is empty). When the distance to the vehicle in front is less than 100m,     the vehicle will keep the distance from the vehicle in front in 3 levels: 30m, 50m, 70m and the allowed distance is +/- 6m. The vehicle will automatically increase       and decrease the speed until the desired distance is reached with the vehicle in front, if the brake pedal is pressed, the system will temporarily operate in normal     mode, press the Res button to continue automatically. Keep your distance from the vehicle in front. When the distance to the vehicle in front is greater than 100m, the   system will operate in Cruise Control mode, allowing the vehicle to run at the initially set speed.
