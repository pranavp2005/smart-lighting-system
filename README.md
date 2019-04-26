# Smart Lighting System

##  Introduction
As part of CS/EEE/INSTR F241 [Microprocessors & Interfacing] we were required to create a 'smart' lighting system for a hypothetical conference room. This repository contains our implementation for this project.
The base idea is that there will be a sliding door to the conference room and that there would pressure plates on each side of the conference room which would trigger the opening and closing of the door. These pressure plates have been modelled using push buttons. To enter the conference room, after the exterior pressure plate has been triggered, the door would open following which the person would get a small interval of about 2-3 seconds to enter and trigger the interior pressure plate [note: these pressure plates would be hidden from the person and the person would not really be aware that they were stepping over them]. After both of the pressure plates have been successfully triggered, the display of the number of people in the room would then be increased by 1. The door will then close albiet after a fairly large time interval. The user may also exit immediately by walking out and triggering the external pressure plate immediately after entering [and the display of the number of people in the room would be deducted accordingly].
Lighting of the rows is handled automatically.

For more details, refer to the final project report.

##  Circuit Diagram Overview
![Overview](/img/Overview.png)

The above image presents an overview of the circuit involved.  

Label | Component(s)
----- | -------------
1 | The CPU [8086] along with 3 octal latches as well as power source and ground.
2 | The PPIs for I/O interfacing.
3 | All of the peripheral [I/O] components - The pressure plates [push buttons], a bipolar stepper motor and it's driver, the seven segment displays, and the LED arrays for each row.
4 | The memory interfacing components - ROM, RAM and additional logic.  

  
## Software Overview
All of the code for running this system lives inside of `/src/code.asm` and the binary file for it which should be loaded into the 8086 lives inside of `/bin/code.com`.

The code was designed to be highly modular, making it easy to modify and/or extend. The central idea behind the design of the code is that there should be an initialization phase followed by a the running of a 'main event loop' (though this is clearly NOT an async system, the concept of an event loop is the same).

For the rest of the explanation, the code (and plethora of docstrings and inline comments) should speak for the itself. But here's an overview of the logic anyways:  
  
![Flowchart](/img/Flowchart.png)

## Possible improvements:
1. Decreasing the time required for the door to close without comprimising on the time alloted for the person to be able to enter.
2. Allowing multiple people to enter/exit at once.
3. Using a switch-per-seat mechanism that would control the lights instead of raw checking of the number of people in the room. In the real world, this would be similar to a spring loaded theatre chair triggering the switch.
