require 'strscan'

class Scanner

# トークン：[記号, [行番号, 値]]
  RESERVED = {
    "COLHDG"    => :COLHDG
  }

  attr_reader :q

  def scan(file)
    @q = []
    lineno = 1

    file.each do |line|
      line = sprintf("%-80s", line).sub("\n", "")
      if line[6] != "*" # コメント除外
        # FORMAT_TYPE フォーマットタイプチェックをそのうち実装する
        @q.push [:A, [lineno, line[5]]] unless line[5] =~ /\A\s+$/
        @q.push [:TYPE_OF_NAME_OR_SPEC, [lineno, line[16]]] unless line[16] =~ /\A\s+$/
        @q.push [:ITEM_NAME, [lineno, line[18..27].strip]] unless line[18..27] =~ /\A\s+$/
        @q.push [:REFERENCE, [lineno, line[28]]] unless line[28] =~ /\A\s+$/
        @q.push [:LENGTH, [lineno, line[29..33].to_i]] unless line[29..33] =~ /\A\s+$/
        @q.push [:DATA_TYPE, [lineno, line[34]]] unless line[34] =~ /\A\s+$/
        @q.push [:DECIMAL_POSITIONS, [lineno, line[35..36].to_i]] unless line[35..36] =~ /\A\s+$/

        next unless line[44..79]
        s = StringScanner.new(line[44..79])
    
        until s.eos?
          case
          when (text = s.scan(/\s+/))
          when (text = s.scan(/\d+/))
            @q.push [:NUMBER, [lineno, text.to_i]]
          when (text = s.scan(/\w+/))
            @q.push [(RESERVED[s[0]] || :IDENT), [lineno, text]]
          when (text = s.scan(/'(.*)'/))
            @q.push [:STRING, [lineno, s[1]]]
          when (text = s.scan(/./))
            @q.push [text, [lineno, text]]
          else
            text = s.string[ss.pos .. -1]
            raise  ScanError, "can not match: '" + text + "'"
          end
        end
        @q.push [:EOL, [lineno, nil]]
      end
      lineno += 1
    end
    @q.push [false, '$']
    @q
  end
end

if __FILE__ == $0
  exit  if ARGV.size != 1
  filename = ARGV.shift
  rex = Scanner.new
  begin
    rex.scan(open(filename)).each {|i| p i }
  rescue
    $stderr.printf  "%s:%d:%s\n", rex.filename, rex.lineno, $!.message
  end
end