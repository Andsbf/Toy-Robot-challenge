require_relative 'robot'
require_relative 'outputs'

class Board
  ORIGIN = { X: 0, Y: 0  }
  SIZE = { X: 6, Y: 6 }

  class RobotMissing < StandardError; end
  class RobotOutOfRange < StandardError; end
  class RobotCollision < StandardError; end

  def initialize (debug: true, output: ConsoleOutput.new, logger: FileOutput.new)
    @robots = {}
    @debug = debug
    # @output where robot's reports are printed/written
    @output = output
    # @logger where debug/logs are printed/written
    @logger = logger
  end

  def process_command command
    robot_name = command[:robot_name]
    details = command[:details]

    robot = @robots[robot_name].dup

    raise RobotMissing if !robot && command[:instruction] != "PLACE"

    case command[:instruction]
    when 'PLACE'
      robot = Robot.new(name: robot_name)
      robot.place(x: details[:x], y: details[:y], face_direction: details[:direction])
    when 'MOVE'
      robot.move
    when 'LEFT'
      robot.turn_left
    when 'RIGHT'
      robot.turn_right
    when 'REPORT'
      @output.write(robot.report)
    end

    validate robot

    @robots[robot_name] = robot

  rescue RobotCollision, RobotOutOfRange, RobotMissing
    @logger.write "Ignoring command: #{command.to_s}" if @debug
  end

  def validate robot
    raise RobotOutOfRange if !position_in_range?(robot.x, robot.y)

    raise RobotCollision if position_over_another_robot?(robot)
  end

  def position_over_another_robot? robot
    @robots
      .select { |robot_name| robot_name != robot.name }
      .map { |robot_name, details| { x:details.x, y:details.y } }
      .any? { |position| (position[:x] == robot.x) && (position[:y] == robot.y)}
  end

  def position_in_range? (x,y)
    x.between?(ORIGIN[:X], SIZE[:X]) && y.between?(ORIGIN[:Y], SIZE[:Y])
  end
end
