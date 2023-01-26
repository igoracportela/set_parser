require_relative "set_parser/version"
require 'bigdecimal'
require 'bigdecimal/util'
require 'safebool'

# Main Class
#
class ConfigParser
  attr_reader :config_file, :params

  def initialize(config_file = nil, separator = '=', comments = ['#', ';'])
    @config_file = config_file
    @params = {}
    @split_regex = "\s*#{separator}\s*"
    @comments = comments
    running
  end

  def running
    return unless config_file

    validate_config
    import_config
  end

  def validate_config
    File.readable?(config_file)
  rescue StandardError
    "#{config_file} is not readable"
  end

  def import_config
    open(config_file) do |f|
      f.each_with_index do |line, index|
        line.strip!
        trait_encoding(line, index)

        is_comment = false
        @comments.each do |comment|
          if /^#{comment}/.match(line)
            is_comment = true
            break
          end
        end

        next if is_comment

        if /#{@split_regex}/.match(line)
          param, value = line.split(/#{@split_regex}/, 2)
          var_name = param.to_s.chomp.strip
          value = value.chomp.strip
          new_value = ''

          return new_value if value.nil?

          if value =~ /^['"](.*)['"]$/
            new_value = Regexp.last_match(1)
          else
            new_value = type_of_value(value)
          end

          add(var_name, new_value)
        elsif /\w+/.match(line)
          add(line.to_s.chomp.strip, true)
        end
      end
    end
  end

  def trait_encoding(line, index)
    begin
      if (index.eql? 0) && line.include?("\xef\xbb\xbf".force_encoding('UTF-8'))
        line.delete!("\xef\xbb\xbf".force_encoding('UTF-8'))
      end
    rescue NoMethodError
      raise "We can't convert your encoding"
    end
  end

  def type_of_value(value)
    return if value.nil?

    return value.to_f if value.to_d.frac.positive?

    return value.to_i if value.to_i.positive?

    return value.to_b if ['true', 'false', 'on', 'off', 'yes', 'no'].include?(value)

    value
  end

  def add(param_name, value, override = false)
    return params[param_name] = value unless value.class.instance_of?(Hash)

    return params[param_name] = value if params.key? param_name

    if params[param_name].class.instance_of?(Hash)
      override ? params[param_name] = value : params[param_name].merge!(value)
    elsif params.key? param_name
      raise ArgumentError, "#{param_name} already exists." if params[param_name].class != value.class
    end
  end
end
