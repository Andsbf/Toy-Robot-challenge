require_relative './lib/dsl'
require_relative './lib/board'

board = Board.new(
  debug: ENV['DEBUG'].nil? ? true : ENV['DEBUG'],
  logger: FileOutput.new("log_#{Time.now.strftime("%Y%m%d%H%M%S")}.txt")
)

instruction_filpath = ARGV[0]

# if file path was given parse instructions from it
if instruction_filpath
  commands = DSL.parse_file instruction_filpath
  commands.each { |command| board.process_command command }

# start interactive mode
else
  puts "[Interactive mode]"
  puts "Enter instructions:"
  puts "(press crtl-d to exit)"

  while true
    input  = gets

    return unless input

    command = DSL.parse_string input.chomp
    board.process_command command if !command.nil?
  end
end
