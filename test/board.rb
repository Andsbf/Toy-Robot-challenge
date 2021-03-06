require "test/unit"
require_relative "../lib/board"

class TestBoard < Test::Unit::TestCase
  def setup
    Robot.class_eval { attr_reader :face_direction }
    Board.class_eval { attr_reader :robots, :output, :logger }
  end

  def test_process_a_place_command
    board = Board.new(output: Output.new, logger: Output.new)

    board.process_command(
      {
        robot_name: 'BOB',
        instruction: 'PLACE',
        details: { x: 1, y: 2, direction: "NORTH" }
      }
    )

    board_robot = board.robots['BOB']

    assert_equal(board_robot.nil?, false )
    assert_equal(board_robot.x, 1 )
    assert_equal(board_robot.y, 2 )
    assert_equal(board_robot.face_direction, "NORTH" )
  end

  def test_process_a_move_command
    board = Helpers.board_with_one_robot

    board.process_command(
      {
        robot_name: 'BOB',
        instruction: 'MOVE',
        details: nil
      }
    )

    board_robot = board.robots['BOB']

    assert_equal(board_robot.x, 0 )
    assert_equal(board_robot.y, 1 )
    assert_equal(board_robot.face_direction, "NORTH" )
  end

  def test_process_a_left_command
    board = Helpers.board_with_one_robot

    board.process_command(
      {
        robot_name: 'BOB',
        instruction: 'LEFT',
        details: nil
      }
    )

    board_robot = board.instance_variable_get(:@robots)['BOB']

    assert_equal(board_robot.x, 0)
    assert_equal(board_robot.y, 0)
    assert_equal(board_robot.face_direction, "WEST" )
  end

  def test_process_a_right_command
    board = Helpers.board_with_one_robot

    board.process_command(
      {
        robot_name: 'BOB',
        instruction: 'RIGHT',
        details: nil
      }
    )

    board_robot = board.instance_variable_get(:@robots)['BOB']

    assert_equal(board_robot.x, 0)
    assert_equal(board_robot.y, 0)
    assert_equal(board_robot.face_direction, "EAST" )
  end

  def test_process_a_report_command
    board = Helpers.board_with_one_robot

    board.process_command(
      {
        robot_name: 'BOB',
        instruction: 'REPORT',
        details: nil
      }
    )

    output = board.output

    assert_equal(output.history[0], "BOB: 0,0,NORTH")
  end

  def test_command_before_place
    board = Board.new(output: Output.new, logger: Output.new, debug: true)

    board.process_command(
      {
        robot_name: 'BOB',
        instruction: 'MOVE',
        details: nil
      }
    )

    board_robot = board.robots['BOB']

    assert_equal(board_robot.nil?, true )
    assert_equal(
      board.logger.history[0],
      'Ignoring command: {:robot_name=>"BOB", :instruction=>"MOVE", :details=>nil}'
    )
  end

  def test_process_a_placement_that_would_collide
    board = Helpers.board_with_one_robot

    board.instance_variable_set(:@debug, true)

    board.process_command(
      {
        robot_name: 'ALICE',
        instruction: 'PLACE',
        details: { x: 0, y: 0, direction: "NORTH" }
      }
    )

    board_robot = board.robots['ALICE']

    assert_equal(board_robot.nil?, true )
    assert_equal(
      board.logger.history[0],
      'Ignoring command: {:robot_name=>"ALICE", :instruction=>"PLACE", :details=>{:x=>0, :y=>0, :direction=>"NORTH"}}'
    )
  end

  def test_process_a_move_that_would_collide
    board = Helpers.board_with_one_robot

    board.instance_variable_set(:@debug, true)

    board.process_command(
      {
        robot_name: 'ALICE',
        instruction: 'PLACE',
        details: { x: 0, y: 1, direction: "SOUTH" }
      }
    )

    board.process_command(
      {
        robot_name: 'ALICE',
        instruction: 'MOVE',
        details: nil
      }
    )

    board_robot = board.robots['ALICE']

    assert_equal(board_robot.nil?, false )
    assert_equal(
      board.logger.history[0],
      'Ignoring command: {:robot_name=>"ALICE", :instruction=>"MOVE", :details=>nil}'
    )
  end

  def test_process_a_move_that_would_get_out_of_edge
    board = Board.new(output: Output.new, logger: Output.new, debug: true)

    board.process_command(
      {
        robot_name: 'BOB',
        instruction: 'PLACE',
        details: { x: 0, y: 0, direction: "SOUTH" }
      }
    )

    board.process_command(
      {
        robot_name: 'BOB',
        instruction: 'MOVE',
        details: nil
      }
    )

    board_robot = board.robots['BOB']

    assert_equal(board_robot.nil?, false )
    assert_equal(
      board.logger.history[0],
      'Ignoring command: {:robot_name=>"BOB", :instruction=>"MOVE", :details=>nil}'
    )
  end

  module Helpers
    def self.board_with_one_robot
      board = Board.new(output: Output.new, logger: Output.new)

      board.process_command(
        {
          robot_name: 'BOB',
          instruction: 'PLACE',
          details: { x: 0, y: 0, direction: "NORTH" }
        }
      )

      board
    end
  end
end
