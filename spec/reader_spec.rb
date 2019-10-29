require_relative "../src/reader"

describe Reader do
  it "reads a file into an array of lines" do
    test_data_result = Reader.read_data_from_file("test_data")
    expect(test_data_result).to eq %w[1 2 3 4 5]
  end

  it "handles a file read error" do
    missing_test_data_result = Reader.read_data_from_file("missing_test_data")
    expect(missing_test_data_result).to be false
  end
end
