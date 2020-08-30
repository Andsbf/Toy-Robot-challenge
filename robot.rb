class Robot
   attr_reader :x, :y, :name

  def initialize(name:, x: nil, y: nil, face_direction: nil)
    @name = name
    @x = x
    @y = y
    @face_direction = face_direction
  end

  def report
    "#{name}: #{x},#{y},#{@face_direction}"
  end

  def place(x: , y: , face_direction:)
    @x = x
    @y = y
    @face_direction = face_direction

    return self
  end

  def turn_left
    case @face_direction
    when 'NORTH'
      @face_direction = 'WEST'
    when 'SOUTH'
      @face_direction = 'EAST'
    when 'EAST'
      @face_direction = 'NORTH'
    when 'WEST'
      @face_direction = 'SOUTH'
    end

    return self
  end

  def turn_right
    case @face_direction
    when 'NORTH'
      @face_direction = 'EAST'
    when 'SOUTH'
      @face_direction = 'WEST'
    when 'EAST'
      @face_direction = 'SOUTH'
    when 'WEST'
      @face_direction = 'NORTH'
    end

    return self
  end

  def move
    case @face_direction
    when 'NORTH'
      @y += 1
    when 'SOUTH'
      @y -= 1
    when 'EAST'
      @x += 1
    when 'WEST'
      @x -= 1
    end

    return self
  end
end
