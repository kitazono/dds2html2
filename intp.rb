# ruby intp.rb C:\Users\TIS301557\Documents\b_src\src\DDS_t\SA0100P.txt

require './intp/scanner.rb'
require './intp/parser.rb'
require './intp/node.rb'

class InterPreter

  def initialize(file_name)
    @file_name = file_name
    begin
      tree = nil
      File.open(@file_name) {|file| tree = Intp::Parser.new.parse(file, @file_name)}
      tree.html
    rescue Racc::ParseError, Intp::IntpError, Errno::ENOENT
      $stderr.puts "#{$0}: #{$!}"
      exit 1
    end
  end

end

InterPreter.new(ARGV[0])