# Author - Igor A. C. Portela | Copyright(c) 2022. All rights reserved.
# github - @igoracportela
#

require_relative "./lib/config_parser"

config = ConfigParser.new('inputs/data.txt')

p config.params
