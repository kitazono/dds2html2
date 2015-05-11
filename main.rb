#coding:utf-8

# ruby main.rb ./src

require './intp/scanner.rb'
require './intp/parser.rb'
require './intp/node.rb'
require './setting.rb'
require 'erb'

$dds_dir = ARGV[0] ? ARGV[0] : "./src"
$html_dir = Dir::pwd + '/html'

class DDSAnalysis

  attr_accessor :file_name, :tree

  def initialize(file_name)
    @file_name = file_name
    @tree = nil
  end

  def parse
    begin
      if RbConfig::CONFIG['host_os'] =~ /^darwin/
        File.open(@file_name) {|file| @tree = Parser.new.parse(file, @file_name)}
      else
        File.open(@file_name, 'r:cp932:utf-8') {|file| @tree = Parser.new.parse(file, @file_name)}
      end
      @tree.evaluate
      @tree
    rescue Racc::ParseError, IntpError, Errno::ENOENT
      $stderr.puts "#{$0}: #{$!}"
      exit 1
    end
  end

  def loc
    File.open(@file_name) {|file| file.count }
  end

end

def html(title, content, out_file)
  result = ERB.new(File.read("layout.html.erb")).result(binding)
  File.open($html_dir + '/' + out_file, "w") do |file|
    file.puts result
  end
end

dir = Dir.open($dds_dir)
dds_list = []
title = ""
total_loc = 0
number_of_files = 0

while name = dir.read

  next if name == "."
  next if name == ".."

  dds = DDSAnalysis.new($dds_dir + '/' +  name)
  dds_tree = dds.parse
  number_of_files += 1
  total_loc += dds.loc

  content = ERB.new(File.read("dds.html.erb")).result(binding)
  html(title, content, name.sub(".txt", ".html"))

  dds_list << [name.sub(".txt", ""), dds_tree.record_length]

end

content = ERB.new(File.read("index.html.erb")).result(binding)
html(title, content, "index.html")
