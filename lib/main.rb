require_relative 'mixtapedata'
def main
  options = ARGV
  if options.length < 3
    raise ArgumentError.new("Missing a file in command line")
  end
  input_file = options[0]
  changes_file = options[1]
  output_file = options[2]
  mixtape_input_data = MixTapeData.new(input_file)
  mixtape_input_data.apply_changes(changes_file)
  mixtape_input_data.save_file(output_file)
end

main