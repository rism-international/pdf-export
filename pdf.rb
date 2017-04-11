require 'nokogiri'
require 'pry'

preprocessing_file=File.new('/tmp/preprocessing.xml', 'w')
doc = File.open("output.xml") { |f| Nokogiri::XML(f)  }
doc.encoding = 'utf-8'
preproc = Nokogiri::XSLT(File.read('preprocessing.xsl'))
preprocessing_xml = preproc.transform(doc)
preprocessing_file.write(preprocessing_xml)

latex_file=File.new('/tmp/example.tex', 'w')
doc = File.open("/tmp/preprocessing.xml") { |f| Nokogiri::XML(f)  }
doc.encoding = 'utf-8'
template = Nokogiri::XSLT(File.read('to_latex.xsl'))
latex = template.transform(doc)
latex_file.write(latex.children.to_s)

#It is necessary to call pdflatex from the output directory
Dir.chdir "/tmp/"
cmd = 'pdflatex -interaction nonstopmode --enable-write18 -shell-escape -output-directory="." example.tex > /dev/null'
system( cmd )
puts "Ready!"
