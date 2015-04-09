# racc -v -g parser.y -o parser.rb

class Parser

rule

  dds       : file_level record_level field_level key_field_level

  file_level : functions

  record_level : TYPE NAME functions


  field_level : data_field
              | field_level data_field

  data_field : NAME length TYPE decimal_positions functions

  length : NUMBER

  decimal_positions : NUMBER
                    |

  key_field_level : 
                  | key_field

  key_field : TYPE NAME functions

  functions :  
            | functions function

  function : IDENT
           | IDENT '(' primary ')'

  primary : STRING

end

---- inner

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
