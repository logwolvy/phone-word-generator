# frozen_string_literal: true

class PhoneEncoding
  DEFAULT_ENCODING = {
    '2' => 'ABC',
    '3' => 'DEF',
    '4' => 'GHI',
    '5' => 'JKL',
    '6' => 'MNO',
    '7' => 'PQRS',
    '8' => 'TUV',
    '9' => 'WXYZ'
  }.freeze

  def initialize(encoding = DEFAULT_ENCODING)
    @encoding = encoding
  end

  def lookup(number)
    encoding[number]
  end

  def reverse_lookup(alphabet)
    reverse_encoding[alphabet]
  end

  private

  attr_reader :encoding

  def reverse_encoding
    # Create alphabet to number mapping
    @reverse_encoding ||= {}.tap do |r|
      encoding.each do |n, str|
        str.strip.split(/\s*/).compact.each do |a|
          r[a.downcase] = n
        end
      end
    end
  end
end
