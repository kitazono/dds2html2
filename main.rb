# ruby main.rb sample.txt

require './intp/scanner.rb'
require './intp/parser.rb'
require './intp/node.rb'

class DDSAnalysis

  def initialize(file_name)
    @file_name = file_name
    begin
      tree = nil
      File.open(@file_name) {|file| tree = Parser.new.parse(file, @file_name)}
      # tree.html
    rescue Racc::ParseError, IntpError, Errno::ENOENT
      $stderr.puts "#{$0}: #{$!}"
      exit 1
    end
  end

end

DDSAnalysis.new(ARGV[0])