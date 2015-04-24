#coding:utf-8

class IntpError < StandardError; end
class IntpArgumentError < IntpError; end

class Node

  attr_reader :file_name
  attr_reader :lineno

  def initialize(file_name, lineno)
    @file_name = file_name
    @lineno = lineno
  end

  def intp_error!(msg)
    raise IntpError, "in #{file_name}:#{lineno}: #{msg}"
  end

  def inspect
    "#{self.class.name}/#{lineno}"
  end

end

class RootNode < Node

  def initialize(file_level, record_level, field_level, key_field_level)
    super(nil, nil)
    @file_level = file_level
    @record_level = record_level
    @field_level = field_level
    @key_field_level = key_field_level
  end

  def record_name
    @record_level.name
  end

  def data_fields
    @field_level
  end

  def key_fields
    @key_field_level
  end

  def record_length
    length = 0
    @field_level.each{|d| length += d.length}
    length
  end

end

class RecordNode < Node

  attr_accessor :type, :name, :functions 

  def initialize(file_name, lineno, type, name, functions)
    super(file_name, lineno)
    @type = type
    @name = name
    @functions = functions
  end

end

class FunctionNode < Node

  attr_reader :name, :argument

  def initialize(file_name, lineno, name, argument = nil)
    super(file_name, lineno)
    @name = name
    @argument = argument
  end

end


class KeyFieldNode < Node

  attr_accessor :name, :type, :functions, :key_sequence

  def initialize(file_name, lineno, type, name, functions)
    super(file_name, lineno)
    @type = type
    @name = name
    @functions = functions
    @key_sequence = nil
  end

end


class DataFieldNode < Node

  attr_reader :name, :length, :type, :decimal_positions, :functions

  def initialize(file_name, lineno, name, length, type, decimal_positions, functions)
    super(file_name, lineno)
    @name = name
    @length = length
    @type = type
    @decimal_positions = decimal_positions
    @functions = functions
  end

end


class RecordFormatNode < Node

  def initialize(file_name, lineno, type_of_name_or_spec, item_name)
    super(file_name, lineno)
    @type_of_name_or_spec = type_of_name_or_spec
    @item_name = item_name
  end

end
