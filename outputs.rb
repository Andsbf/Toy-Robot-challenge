class Output
  attr_reader :history

  def initialize
    @history = []
  end

  def write param
    @history << param
  end
end

class ConsoleOutput < Output
  def write param
    super param

    puts param
  end
end

class FileOutput < Output
  def self.unique_filename filename
    if !File.file?(filename)
      filename
    else
      # append `(1)` before file extension
      return FileOutput.unique_filename filename.gsub(/(\.[^\.]+)$/, '(1)'+'\1')
    end
  end

  def initialize filename = (Time.now.strftime("%Y%m%d%H%M%S") + ".txt")
    super()

    File.open(filename, "w") {}

    @filename = FileOutput.unique_filename(filename)
  end

  def write param
    super param

    File.open("./#{@filename}", 'a') { |file| file.puts param}
  end
end
