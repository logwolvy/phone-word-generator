require 'optparse'

module OptionParserHelper
  def self.included(base)
    base.class_eval do
      OptionParser.new do |parser|
        parser.on('-d', '--dict /path/to/dict', 'Path to dict file') do |v|
          base::APPLICATION_CONFIG[:dict_path] = v.strip
        end
        parser.on('-p', '--phone /path/to/phone_number_list', 'Path to phone number list file') do |v|
          base::APPLICATION_CONFIG[:number_file_path] = v.strip
        end
      end.parse!
    end
  end
end
