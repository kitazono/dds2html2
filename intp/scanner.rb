#coding:utf-8

require 'strscan'

class Scanner

  # トークン：[記号, [行番号, 値]]
  
  RESERVED = {
    "EQ"    => :EQ,
    "NE"    => :NE
  }

  attr_reader :q

  def scan(file)
    @q = []
    file.each do |line|
      line = sprintf("%-80s", line).sub("\n", "")
      # コメント以外
      if line[6] != "*"
        @q.push [:TYPE, [file.lineno, line[16]]] unless line[16] =~ /\A\s+$/
        @q.push [:NAME, [file.lineno, line[18..27].strip]] unless line[18..27] =~ /\A\s+$/
        @q.push [:REFERENCE, [file.lineno, line[28]]] unless line[28] =~ /\A\s+$/
        @q.push [:LENGTH, [file.lineno, line[29..33].to_i]] unless line[29..33] =~ /\A\s+$/
        @q.push [:FILE_TYPE, [file.lineno, line[34]]] unless line[34] =~ /\A\s+$/
        @q.push [:NUMBER, [file.lineno, line[35..36].to_i]] unless line[35..36] =~ /\A\s+$/

        next unless line[44..79]
        s = StringScanner.new(line[44..79])
    
        until s.eos?
          case
          when (text = s.scan(/\s+/))
          when (text = s.scan(/\d+/))
            @q.push [:NUMBER, [file.lineno, text.to_i]]
          when (text = s.scan(/\w+/))
            @q.push [(RESERVED[s[0]] || :IDENT), [file.lineno, text]]
          when (text = s.scan(/'(.*?)'/))
            @q.push [:STRING, [file.lineno, s[1]]]
          when (text = s.scan(/'(.*)\+/))
            @q.push [:STRING, [file.lineno, s[1]]]
          when (text = s.scan(/(?!\()(.*)'/))
            @q.push [:STRING, [file.lineno, s[1]]]
          when (text = s.scan(/./))
            @q.push [text, [file.lineno, text]]
          else
            text = s.string[ss.pos .. -1]
            raise  ScanError, "can not match: '" + text + "'"
          end
        end
      end
    end
    @q.push [false, '$']
    @q
  end
end

if __FILE__ == $0
  exit  if ARGV.size != 1
  file_name = ARGV.shift
  rex = Scanner.new
  begin
    rex.scan(open(file_name)).each {|i| p i }
  rescue
    $stderr.printf  "%s:%d:%s\n", rex.file_name, rex.file.lineno, $!.message
  end
end