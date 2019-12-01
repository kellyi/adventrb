# A module for reading data files
module Reader
  def self.read_data_from_file(filename, custom_split_char = nil)
    filename_with_path = "./data/#{filename}.txt"
    split_args = custom_split_char ? [:split, custom_split_char] : [:split]
    File.exist?(filename_with_path) && File.open(filename_with_path).read.send(*split_args)
  end
end
