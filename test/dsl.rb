require "test/unit"
require_relative "../lib/dsl"

class TestDSL < Test::Unit::TestCase
  def test_parse_a_command
    dsl = DSL.new(commands: ['aNAME: aCOMMAND'])

    command = dsl.parse_commands[0]

    assert_equal(command[:robot_name], "aNAME" )
    assert_equal(command[:instruction], "aCOMMAND" )
    assert_equal(command[:details], nil )
  end

  def test_parse_a_place_comand
    dsl = DSL.new(commands: ['aNAME: PLACE  1,3,SOUTH'])

    command = dsl.parse_commands[0]

    assert_equal(command[:robot_name], "aNAME" )
    assert_equal(command[:instruction], "PLACE")
    assert_equal(command[:details][:x], 1)
    assert_equal(command[:details][:y], 3)
    assert_equal(command[:details][:direction], 'SOUTH')
  end

  def test_parse_a_invalid_comand
    logger = Output.new
    dsl = DSL.new(commands: ['asdasd'], debug: true, logger: logger)

    commands = dsl.parse_commands

    assert_equal(commands.length, 0)
    assert_send([dsl.logger.history, :include?, "No able to parse command: asdasd"])
  end

  def test_parse_multiple_commands
    dsl = DSL.new(
      commands: [
        'aNAME: PLACE  1,3,SOUTH',
        'anotherNAME: MOVE'
      ]
    )

    place_command, move_command = dsl.parse_commands

    assert_equal(place_command[:robot_name], "aNAME" )
    assert_equal(place_command[:instruction], "PLACE")
    assert_equal(place_command[:details][:x], 1)
    assert_equal(place_command[:details][:y], 3)
    assert_equal(place_command[:details][:direction], 'SOUTH')


    assert_equal(move_command[:robot_name], "anotherNAME" )
    assert_equal(move_command[:instruction], "MOVE")
  end
end
