# A module for reading data files
module Reader
  def self.read_data_from_file(filename)
    filename_with_path = "./data/#{filename}.txt"
    File.exist?(filename_with_path) && File.open(filename_with_path).read.split
  end
end
