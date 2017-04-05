require 'nokogiri'
require 'pry'
ofile=File.new('/tmp/proc.tex', 'w')
doc = File.open("/tmp/template.xml") { |f| Nokogiri::XML(f)  }
doc.encoding = 'utf-8'
template = Nokogiri::XSLT(File.read('proc.xsl'))
latex = template.transform(doc)
ofile.write(latex.children.to_s)

#It is necessary to call pdflatex from the output directory
#Dir.chdir "/tmp/"
#cmd = 'pdflatex -interaction nonstopmode --enable-write18 -shell-escape -output-directory="." example.tex > /dev/null'
#system( cmd )
puts "Ready!"
