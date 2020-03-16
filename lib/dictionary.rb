# frozen_string_literal: true

class Dictionary
  def initialize(file_path, encoding = PhoneEncoding.new)
    @words = IO.readlines(file_path).map { |w| w.gsub(/\W+/, '') }
    @encoding = encoding
  end

  def include?(word)
    words.include?(word)
  end

  def reverse_lookup(number)
    reverse_lookup_dict[number]
  end

  private

  attr_reader :words, :encoding

  def reverse_lookup_dict
    # Create number to dict word mapping
    @reverse_lookup_dict ||= words.map do |w|
      # Encode word as numbers
      number = w.strip.split(/\s*/).compact.map do |c|
        encoding.reverse_lookup(c)
      end.join

      [number, w]
    end.to_h
  end
end
