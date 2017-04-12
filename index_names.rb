require 'nokogiri'
require 'pry'

pre_file=File.new('/tmp/index_names_pre.xml', 'w')
doc = File.open("/tmp/preprocessing.xml") { |f| Nokogiri::XML(f)  }
doc.encoding = 'utf-8'
template = Nokogiri::XSLT(File.read('index_names_pre.xsl'))
pre = template.transform(doc)
pre_file.write(pre.children.to_s)


index_file=File.new('/tmp/index_names.tex', 'w')
template = Nokogiri::XSLT(File.read('index_names.xsl'))
regis = template.transform(pre)
index_file.write(regis.children.to_s)


#It is necessary to call pdflatex from the output directory
Dir.chdir "/tmp/"
cmd = 'pdflatex -interaction nonstopmode --enable-write18 -shell-escape -output-directory="." index_names.tex > /dev/null'
system( cmd )
puts "Ready!"
