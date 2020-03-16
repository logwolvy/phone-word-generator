# frozen_string_literal: true

require_relative 'phone_encoding'
require_relative 'dictionary'
require_relative 'option_parser_helper'

module PhoneWordGenerator
  APPLICATION_CONFIG = {} # DO NOT FREEZE THIS
  include OptionParserHelper

  class Application
    attr_reader :phone_words

    def initialize
      @encoding = PhoneEncoding.new
      @dictionary = Dictionary.new(APPLICATION_CONFIG[:dict_path])
      @input_mode = APPLICATION_CONFIG[:number_file_path] ? :file : :stdin

      @phone_numbers = @input_mode.eql?(:file) ? IO.readlines(
        APPLICATION_CONFIG[:number_file_path]
      ).map { |w| w.gsub(/\W+/, '') } : []
    end

    def call
      if input_mode.eql?(:stdin)
        process_console_input
      else
        generate_phone_words
      end
    end

    private

    attr_reader :dictionary, :input_mode, :phone_numbers

    def process_console_input
      loop do
        puts 'Please enter a phone number to convert...'
        number = gets.chomp
        phone_numbers[0] = number
        generate_phone_words
      end
    end

    def generate_phone_words
      @phone_words = {}

      phone_numbers.each do |orig_ph|
        @current_number = orig_ph
        @matched_phone_words = []
        match_current_number
        merge_matched_phone_words
        puts "#{orig_ph} ---> #{@current_number}"
        @phone_words[orig_ph] = @current_number
      end
    end

    def match_current_number(start_index = 0, end_index = -1)
      number = @current_number.dup[start_index..end_index]
      return if number.nil? || number.length <= 1

      if (match = dictionary.reverse_lookup(number))
        @current_number.dup.tap do |dup_num|
          dup_num[start_index..end_index] = match
          @matched_phone_words << dup_num
        end
      end

      match_substr(start_index, end_index)
      # Check for relative inner string
      match_current_number(start_index + 1, end_index - 1)
    end

    def match_substr(start_index, end_index, partition_ptr = 1)
      # TODO: Implement dictionary as Trie for easy substr checks
      number = @current_number.dup[start_index..end_index]
      return if partition_ptr >= number.length

      @current_number.dup.tap do |dup_num|
        # Naive implementation to get phone number substrings
        dup_num[start_index..end_index] = number.chars
                                                .partition.with_index { |_, i| i < partition_ptr }
                                                .map do |substr_arr|
          sub_str = substr_arr.join
          if (match = dictionary.reverse_lookup(sub_str))
            match
          else
            sub_str
          end
        end.flatten.join
        @matched_phone_words << dup_num
      end

      match_substr(start_index, end_index, partition_ptr + 1)
    end

    def merge_matched_phone_words
      @matched_phone_words = @matched_phone_words.uniq.reject { |n| n == @current_number }
      dup_current_num = @current_number.dup
      dup_current_num.chars.each.with_index do |_c, i|
        @matched_phone_words.each do |w|
          dup_current_num[i] = w[i] if w[i] =~ /\D/
        end
      end
      @current_number = dup_current_num
    end
  end
end
