require_relative 'outputs'

class DSL
  def self.parse_file file_path
    commands = File.readlines(file_path, chomp: true)

    instance = new(commands: commands)
    instance.parse_commands
  end

  attr_reader :logger

  def initialize(commands:, debug: ENV['DEBUG'], logger: ConsoleOutput.new)
    @commands = commands
    @debug = debug.to_s == "true"
    @logger = logger
  end

  def parse_commands
    @commands
      .map { |command| parse_command command }
      .select { |command| command != nil } # remove invalid commands
      .map { |command| parse_details command }
  end

  private

  def parse_command command
    command_match = command.match(/^(?<robot_name>\S*): (?<instruction>.\S*)(?:\s+(?<details>\S*))?/)

    command_data = {
      robot_name: command_match[:robot_name],
      instruction: command_match[:instruction],
      details: command_match[:details]
    }

  rescue
    @logger.write "Invalid command: #{command.to_s}" if @debug
    return nil
  end

  def parse_details command
    case command[:instruction]
    when 'PLACE'
      return parse_place_details command
    else
      return command
    end
  end

  def parse_place_details command
    x, y, direction = command[:details].split(',')

    command.merge(
      {
        details: {
          x: Integer(x),
          y: Integer(y),
          direction: direction
        }
      }
    )
  end
end
