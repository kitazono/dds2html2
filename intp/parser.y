# racc -v -g parser.y -o parser.rb

class Parser

options no_result_var

rule

  dds       : file_level record_level field_level key_field_level
                {
                  RootNode.new(val[0], val[1], val[2], val[3])
                }

  file_level : functions

  record_level : TYPE NAME functions
                {
                  RecordNode.new(@file_name, val[0][0], val[0][1], val[1][1], val[2])
                }

  field_level : data_field
                   {
                      [val[0]]                
                   }
              | field_level data_field
                  {
                    val[0].push(val[1])
                  }

  data_field : NAME length TYPE decimal_positions functions
                  {
                    DataFieldNode.new(@file_name, val[0][0], val[0][1], val[1][1], val[2][1], val[3][1], val[4])
                  }

  length : NUMBER

  decimal_positions : NUMBER
                    |
                        {
                          [nil, nil]
                        }


  key_field_level : 
                      {
                        @key_sequence = 0
                        {}
                      }
                  | key_field_level key_field
                      {
                        @key_sequence += 1
                        val[1].key_sequence = @key_sequence 
                        val[0].store(val[1].name, val[1])
                        val[0]
                      }


  key_field : TYPE NAME functions
            {
              KeyFieldNode.new(@file_name, val[0][0], val[0][1], val[1][1], val[2])
            }

  functions :
                {
                  []
                }
            | functions function
                {
                  val[0].push(val[1])
                }

  function : IDENT
            {
               FunctionNode.new(@file_name, val[0][0], val[0][1])
            }
           | IDENT '(' STRING ')'
            {
               FunctionNode.new(@file_name, val[0][0], val[0][1], val[2][1])
            }

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
