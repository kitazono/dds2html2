#coding:utf-8

# ruby main.rb ./src

require './intp/scanner.rb'
require './intp/parser.rb'
require './intp/node.rb'
require 'erb'

class DDSAnalysis

  attr_accessor :file_name, :tree

  def initialize(file_name)
    @file_name = file_name
    begin
      tree = nil
      File.open(@file_name, 'r:cp932:utf-8') {|file| @tree = Parser.new.parse(file, @file_name)}
    rescue Racc::ParseError, IntpError, Errno::ENOENT
      $stderr.puts "#{$0}: #{$!}"
      exit 1
    end
  end

end

$dds_dir = ARGV[0]
$html_dir = Dir::pwd + '/html'

dir = Dir.open($dds_dir)
dds_list = []

while name = dir.read

  next if name == "."
  next if name == ".."

  dds = DDSAnalysis.new($dds_dir + '/' +  name)
  title = ""
  layout = ""
  content = ERB.new(File.read("dds.html.erb")).result(binding)
  result = ERB.new(File.read(layout)).result(binding)
  File.open($html_dir + '/' + name.sub(".txt", ".html"), "w") do |file|
    file.puts result
  end

  dds_list << [name.sub(".txt", ""), dds.tree.record_length]

end

title = ""
layout = ""
content = ERB.new(File.read("index.html.erb")).result(binding)
result = ERB.new(File.read(layout)).result(binding)
File.open($html_dir + '/' + "index.html", "w") do |file|
  file.puts result
end
