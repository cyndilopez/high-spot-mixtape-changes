class MixTapeData

  def initialize(input_filename)
    @mixtape_data = readFile(input_filename)
  end

  def readFile(input_filename)
    begin
      file = File.read(filepath)
    rescue
      raise ArgumentError.new("Cannot read json input file")
    end
    return JSON.parse(file)
  end

end

