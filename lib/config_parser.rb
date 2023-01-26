require_relative "set_parser/version"
require 'bigdecimal'
require 'bigdecimal/util'
require 'safebool'

# Main Class
#
class ConfigParser
  ATTRS = %i[file params].freeze

  attr_reader(*ATTRS)

  def initialize(filepath:, separator: '=', comments: ['#', ';'])
    @comments = comments
    @file = filepath
    @params = {}
    @split_regex = "\s*#{separator}\s*"
  end

  def call
    return unless validate_file_readability

    reading_file
  end

  def validate_file_readability
    File.readable?(@file)
  rescue Errno::ENOENT
    p "File or directory #{@file} doesn't exist."
  rescue Errno::EACCES
    p "Can't read from #{@file}. No permission."
  end

  def reading_file
    File.open(file) do |file|
      file.each_with_index do |line, index|
        line.strip!
        trait_encoding(line, index)

        next if trait_comments(line)

        check_rules(line)
      end
    end
  end

  def trait_encoding(line, index)
    if (index.eql? 0) && line.include?("\xef\xbb\xbf".force_encoding('UTF-8'))
      line.delete!("\xef\xbb\xbf".force_encoding('UTF-8'))
    end
  rescue NoMethodError
    raise "We can't convert your encoding"
  end

  def trait_comments(line)
    is_comment = false

    @comments.map do |comment|
      is_comment = true if /^#{comment}/.match(line)
    end

    is_comment
  end

  def check_rules(line)
    if /#{@split_regex}/.match(line)
      trait_and_add_params(line)
    elsif /\w+/.match(line)
      add_to_hash(line.to_s.chomp.strip, true)
    end
  end

  def trait_and_add_params(line)
    param, value = line.split(/#{@split_regex}/, 2)
    var_name = param.to_s.chomp.strip
    value = value.chomp.strip
    new_value = trait_new_value_hash_element(value)

    add_to_hash(var_name, new_value)
  end

  def trait_new_value_hash_element(value)
    return Regexp.last_match(1) if value =~ /^['"](.*)['"]$/

    type_of_value(value)
  end

  def type_of_value(value)
    return if value.nil?

    return value.to_f if value.to_d.frac.positive?

    return value.to_i if value.to_i.positive?

    return value.to_b if ['true', 'false', 'on', 'off', 'yes', 'no'].include?(value)

    value
  end

  def add_to_hash(param_name, value, override: false)
    return params[param_name] = value unless value.class.instance_of?(Hash)

    return params[param_name] = value if params.key? param_name

    if params[param_name].class.instance_of?(Hash)
      override ? params[param_name] = value : params[param_name].merge!(value)
    elsif params.key? param_name
      raise ArgumentError, "#{param_name} already exists." if params[param_name].class != value.class
    end
  end
end
