#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.12
# from Racc grammer file "".
#

require 'racc/parser.rb'
class Parser < Racc::Parser

module_eval(<<'...end parser.y/module_eval...', 'parser.y', 40)

  def parse(file, file_name)
    @file_name = file_name
    @q = Scanner.new.scan(file)
    @yydebug = true
    do_parse
  end

  def next_token
    @q.shift
  end

  def on_error(t, v, values)
    if v
      line = v[0]
      v = v[1]
    else
      line = 'last'
    end
    raise Racc::ParseError, "#{@file_name}:#{line}: syntax error on #{v.inspect}"
  end
...end parser.y/module_eval...
##### State transition tables begin ###

racc_action_table = [
    18,    12,    20,     8,     9,    12,    13,    14,     4,     6,
    23,    24,    25,     8,    26,    29,     8,     8 ]

racc_action_check = [
    10,    10,    12,     3,     4,     5,     6,     8,     1,     2,
    14,    18,    19,    21,    22,    25,    27,    30 ]

racc_action_pointer = [
   nil,     8,     7,    -2,     4,     2,     3,   nil,     1,   nil,
    -2,   nil,    -2,   nil,     2,   nil,   nil,   nil,     8,    10,
   nil,     8,     7,   nil,   nil,    11,   nil,    11,   nil,   nil,
    12 ]

racc_action_default = [
   -13,   -18,   -18,    -2,   -18,   -18,   -18,   -14,   -15,    31,
   -10,    -4,   -18,   -13,   -18,    -1,    -5,   -11,   -18,   -18,
    -7,    -3,   -18,   -17,   -13,    -9,   -16,   -12,   -13,    -8,
    -6 ]

racc_goto_table = [
     3,    11,     1,    10,    15,     5,    16,     2,    19,    28,
    17,    22,   nil,    21,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,    27,   nil,   nil,   nil,    30 ]

racc_goto_check = [
     6,     7,     1,     4,     5,     3,     7,     2,     8,     9,
    10,    12,   nil,     6,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,     6,   nil,   nil,   nil,     6 ]

racc_goto_pointer = [
   nil,     2,     7,     3,    -2,    -6,     0,    -4,    -4,   -16,
     0,   nil,    -3 ]

racc_goto_default = [
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,     7,   nil ]

racc_reduce_table = [
  0, 0, :racc_error,
  4, 10, :_reduce_none,
  1, 11, :_reduce_none,
  3, 12, :_reduce_none,
  1, 13, :_reduce_none,
  2, 13, :_reduce_none,
  5, 16, :_reduce_none,
  1, 17, :_reduce_none,
  1, 18, :_reduce_none,
  0, 18, :_reduce_none,
  0, 14, :_reduce_none,
  1, 14, :_reduce_none,
  3, 19, :_reduce_none,
  0, 15, :_reduce_none,
  2, 15, :_reduce_none,
  1, 20, :_reduce_none,
  4, 20, :_reduce_none,
  1, 21, :_reduce_none ]

racc_reduce_n = 18

racc_shift_n = 31

racc_token_table = {
  false => 0,
  :error => 1,
  :TYPE => 2,
  :NAME => 3,
  :NUMBER => 4,
  :IDENT => 5,
  "(" => 6,
  ")" => 7,
  :STRING => 8 }

racc_nt_base = 9

racc_use_result_var = true

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "TYPE",
  "NAME",
  "NUMBER",
  "IDENT",
  "\"(\"",
  "\")\"",
  "STRING",
  "$start",
  "dds",
  "file_level",
  "record_level",
  "field_level",
  "key_field_level",
  "functions",
  "data_field",
  "length",
  "decimal_positions",
  "key_field",
  "function",
  "primary" ]

Racc_debug_parser = true

##### State transition tables end #####

# reduce 0 omitted

# reduce 1 omitted

# reduce 2 omitted

# reduce 3 omitted

# reduce 4 omitted

# reduce 5 omitted

# reduce 6 omitted

# reduce 7 omitted

# reduce 8 omitted

# reduce 9 omitted

# reduce 10 omitted

# reduce 11 omitted

# reduce 12 omitted

# reduce 13 omitted

# reduce 14 omitted

# reduce 15 omitted

# reduce 16 omitted

# reduce 17 omitted

def _reduce_none(val, _values, result)
  val[0]
end

end   # class Parser
