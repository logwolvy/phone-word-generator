# frozen_string_literal: true

require 'minitest/autorun'
require 'phone_word_generator'

class PhoneWordGeneratorTest < Minitest::Test
  def test_phone_words_generation
    generator.call
    assert_equal generated_words, generator.phone_words
  end

  private

  def generator
    @generator ||= begin
      PhoneWordGenerator::APPLICATION_CONFIG[:dict_path] = File.expand_path('./dictionary.txt', __dir__)
      PhoneWordGenerator::APPLICATION_CONFIG[:number_file_path] = File.expand_path('./phone_number_list.txt', __dir__)
      PhoneWordGenerator::Application.new
    end
  end

  def generated_words
    { '43556225563' => 'hellocallme', '35495730957' => '35495730957' }
  end
end
