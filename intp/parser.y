# racc -o parser.rb parser.y

class Intp::Parser

rule

  dds       : stmt_list
                {
                  result = RootNode.new(val[0])
                }

  stmt_list :
                {
                  result = []
                }
            | stmt_list EOL
            | stmt_list stmt EOL
                {
                  result.push(val[1])
                }
            | stmt_list EOF
                {
                }

  stmt      : record_format
            | field

  field : A ITEM_NAME LENGTH DATA_TYPE DECIMAL_POSITIONS COLHDG '(' STRING ')'
                {
                  result = FieldNode.new(@file_name, val[1][0], val[1][1], val[2][1], val[3][1], val[4][1], val[6][1])
                }

        | A ITEM_NAME LENGTH DATA_TYPE COLHDG '(' STRING ')'
                {
                  result = FieldNode.new(@file_name, val[1][0], val[1][1], val[2][1], val[3][1], nil, val[6][1])
                }

  record_format : A TYPE_OF_NAME_OR_SPEC ITEM_NAME
                {
                  result = RecordFormatNode.new(@file_name, val[1][0], val[1][1], val[2][1])
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
