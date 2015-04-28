#coding:utf-8

class IntpError < StandardError; end
class IntpArgumentError < IntpError; end


class Node

  attr_reader :file_name, :lineno

  @@start_digit = 0
  @@record_length = 0
  @@key_sequence = 0

  def initialize(file_name, lineno)
    @file_name = file_name
    @lineno = lineno
  end

  def exec_list(nodes)
    v = nil
    nodes.each {|node| v = node.evaluate}
    v
  end

  def intp_error!(msg)
    raise IntpError, "in #{file_name}:#{lineno}: #{msg}"
  end

  def inspect
    "#{self.class.name}/#{lineno}"
  end

end


class RootNode < Node

  attr_accessor :file_level, :record_level, :field_level, :key_field_level, :record_length

  def initialize(file_level, record_level, field_level, key_field_level)
    super(nil, nil)
    @file_level = file_level
    @record_level = record_level
    @field_level = field_level
    @key_field_level = key_field_level
    
  
    @@start_digit = 1
    @@record_length = 0
    @@key_sequence = 0
  end

  def evaluate
    dds =  @record_level.evaluate
    @field_level = dds.field_level if dds
    exec_list(@field_level)
    @record_length = @@record_length
  end

  def data_fields
    @field_level
  end

  def key_fields
    @key_field_level
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

  def evaluate
    v = nil
    @functions.each{|f| v = f.evaluate }
    v
  end

end


class FunctionNode < Node

  attr_reader :name, :argument

  def initialize(file_name, lineno, name, argument = nil)
    super(file_name, lineno)
    @name = name
    @argument = argument
  end

  def evaluate
    if @name == "PFILE"
      DDSAnalysis.new($dds_dir + '/' +  argument + ".txt").parse
    end
  end

end


class KeyFieldNode < Node

  attr_accessor :name, :type, :functions, :key_sequence

  def initialize(file_name, lineno, type, name, functions)
    super(file_name, lineno)
    @type = type
    @name = name
    @functions = functions
    @@key_sequence += 1
    @key_sequence = @@key_sequence
  end

end


class DataFieldNode < Node

  attr_reader :name, :length, :type, :decimal_positions, :functions, :start_digit, :end_digit, :byte, :name_j

  def initialize(file_name, lineno, name, length, type, decimal_positions, functions)
    super(file_name, lineno)
    @name = name
    @length = length
    @type = type
    if type == "P"
      @byte = length / 2 + 1
    else
      @byte = length
    end
    @decimal_positions = decimal_positions
    @functions = functions
    @name_j = functions.find{ |f| f.name == "COLHDG" || f.name == "TEXT"}.argument
  end

  def evaluate
    @start_digit = @@start_digit
    @end_digit = @start_digit + @length - 1
    @@start_digit = @end_digit + 1

    @@record_length += @length
  end

end


class RecordFormatNode < Node

  def initialize(file_name, lineno, type_of_name_or_spec, item_name)
    super(file_name, lineno)
    @type_of_name_or_spec = type_of_name_or_spec
    @item_name = item_name
  end

end
