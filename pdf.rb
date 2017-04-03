require 'nokogiri'
require 'pry'
ofile=File.new('/tmp/out.tex', 'w')
doc = File.open("dnla.xml") { |f| Nokogiri::XML(f)  }
doc.encoding = 'utf-8'
template = Nokogiri::XSLT(File.read('to_latex.xsl'))
latex = template.transform(doc)
ofile.write(latex.children.to_s)
#It is necessary to call pdflatex from the output directory
Dir.chdir "/tmp/"
cmd = 'pdflatex -interaction nonstopmode --enable-write18 -shell-escape -output-directory="." out.tex > /dev/null'
system( cmd )
puts "Ready!"
