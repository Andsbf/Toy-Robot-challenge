

# The Toy Robot challenge

The challenge is to simulate a toy robot moving on a square board of 6 x 6 units.

## Getting Started

This is a pure ruby project, ruby 2.4.6 was used for development of this project, so either 2.4.6 version or higher is recommended.

PS: Lower versions should work fine, as I can't remember using anything from ruby latests version, but it was not tested on a lower version.

### Modes
The program can be used in two ways, a file can be provided as an input/argument, and robots instructions would be parsed from the file. Or Interactive-mode, where the user instructions would be typed in the console and executed.

Eg.
Read from file:
```
ruby main.rb ./instruction_sample.txt
```

Read from CLI:
```
ruby main.rb

[Interactive mode]
Enter instructions:
(press crtl-d to exit)

ALICE: PLACE 0,0,NORTH
ALICE: MOVE
...
```

## How it works
The program can be logically breakdown in 2 parts.

* The DSL parser, class responsible for parsing the commands
* The Board and Robot classes, where the parsed commands are applied to.

### Outputs

The program has 2 possible outputs, the console/terminal or a file. By default the program will output to the console/terminal, but this is configurable when instantiating a board.

https://github.com/Andsbf/Toy-Robot-challenge/blob/master/lib/board.rb#L12

## Running the tests

Run all the tests:
```
ruby ./test/all.rb
```

### Debugging
The program reads from the environment the flag `DEBUG`, in case the flag is on/true, all the logging will be done according to the logging method selected, by default the program will log to a file, but this is configurable(the terminal/console can also be used for debugging). If the DEBUG environment variable is set to false, the log file for the program execution will be empty. The Default for the DEBUG is true, for the sake of this exercise.

ps: The default debugging method will create a file named with the current timestamp at the root of the project.

Eg:

The `instruction_sample.txt` has 3 invalid commands(a command before a placement, a placement on top of another robot and a collision), after after running:

```
ruby main.rb ./instruction_sample.txt
```

A file like `log_20200831092219.txt`(log_timestamp.txt) will be created including the logging for that program excuction, in this case the list of the 3 invalid commands.

Example of logging to console:

```
# When instantiating the board
  Board.new(logger: ConsoleOutput.new)
```

### Outputs & Log

It has to be clear that the output is where the robot's reports will be "write/printed" and logs are for execution execptions/debugging.

## Considerations:

* File structure: This is a really opinated topic, so I tried to keep it simple and shallow as every company has its standards
* Code Style/Linter: same as File Structure.
* I found the following rules hard to understand, they sound the same to me
  * A toy robot must not hit the edges of the board during movement, including when the robot is initially
placed on the board.
  * Any move that would cause the robot to fall off the edge of the board or collide with another robot
must be ignored.

Specially because on the given `example 2`, from the code challenge requirements, the robot is already place on the edge.
```
BOB: PLACE 0,0,NORTH
BOB: LEFT
BOB: REPORT
```
I used some commom sense and coded it considering the robots could not go over the edge, in case my logic is not right I would be more than happy to submit a patch/new commit once we clarify it.

### Possible improvements, if this was a real project:
  * Create Command classes, like: PlaceCommand, MoveCommand,..., so the board `process_command` would do a type check instead of a match on the instruction string
  ```
  case command[:instruction]
    when 'PLACE'
    ...
  ```
  would be:
  ```
  case command.class
    when PlaceCommand
    ...
    when MoveCommand
  ```

  * Create value Object "Position", so we could more easily compare possitions. Like robot_a.posistion == robot_b.position
  * More specific logging for the "invalid commands", add reason for the command be invalid
  * Use a proper testing framework, like RSPEC
  * Make the Output and Log method selectable through Env variable
  * Create Constants file and move the directions 'NORT,'
  * Make the commands processing case insesitive? that would a project decision...
  * There is a endless number of improvements/polishing that can be done on any project, it is hard to know when to stop without knowing the bigger scope of a project, like where/how this program would be used. If you guys would like to polish the program more, I would be happy to push more commits addressing more specific requirements.
