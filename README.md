Martian Robots
==============

Martian robots is an application that allows you to remotely control robots on the surface of Mars.

Requirements
------------

- OS: Mac OSX or Linux
- Ruby 1.9.3

Starting Martian Robots
-----------------------

Either:
- Double click on the 'martian_robots' executable. If prompted, click on 'Run in Terminal'

Or:
- In a terminal, navigate to the application directory and type:
```$ ruby martian_robots.rb```

How To Use
----------

Start by defining a grid on the surface of Mars by giving a width and height like this:

    Grid size(W H): 20 25

This will make a grid that is 20 grid spaces wide and 25 grid spaces high. The maximum is 50 by 50

Next, you are ready to add robots to the grid. Do this by giving them grid coordinates and direction in which to face, like this:

    Robot 1 position (X Y DIR): 5 5 N

This will add a robot to the grid at grid coordinates 5 5 facing north.

Give your robot instructions. The default instructions are:
  - L: Turn the robot 90 degrees anti-clockwise on its current position
  - R: Turn the robot 90 degrees clockwise on its current position
  - F: Move the robot forward by one grid space in the direction it is facing

Type ```help``` at any time to list these instructions
Give your instructions as a string (maximum 100 instructions), like this:

    Instrutions for Robot 1: FFLFLFRFFF

You can only give the robot one string of instructions.
You will be notified if your robot moves outside the boundaries of the grid. When this happens, the robot leaves a scent. If you instruct any robot to move off the grid from the same gridpoint, it will reject the instructions.

Once the robot has processed the instructions you will be prompted to add another to the grid.

Special Commands
----------------

These are commands that you can type at any time:

```exit```: Exit the program

```where```: List the position of all robots

```lost```: Lists the last positions of all robots that have been lost

```ongrid```: Lists the positions of all robots that are on the grid

```grid```: Displays the size of the grid

```help```: Lists the robot instructions and special commands
