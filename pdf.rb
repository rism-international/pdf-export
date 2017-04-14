require 'nokogiri'
require 'pry'

#Inputfile
doc = File.open("../output.xml") { |f| Nokogiri::XML(f)  }
doc.encoding = 'utf-8'

#Preprocessing
preprocessing_file=File.new('/tmp/preprocessing.xml', 'w')
latex_file=File.new('/tmp/example.tex', 'w')
preproc = Nokogiri::XSLT(File.read('stylesheets/preprocessing.xsl'))
preprocessing_xml = preproc.transform(doc)
preprocessing_file.write(preprocessing_xml)

#Creating the corpus
template = Nokogiri::XSLT(File.read('stylesheets/to_latex.xsl'))
latex = template.transform(preprocessing_xml)

#Creating the people index
template = Nokogiri::XSLT(File.read('stylesheets/index_names_pre.xsl'))
pre = template.transform(preprocessing_xml)

regfile = File.new("/tmp/names.xml", "w")
regfile.write(pre)

template = Nokogiri::XSLT(File.read('stylesheets/index_names.xsl'))
regis = template.transform(pre)

#Creating the title index
template = Nokogiri::XSLT(File.read('stylesheets/index_title_pre.xsl'))
pre = template.transform(preprocessing_xml)
template = Nokogiri::XSLT(File.read('stylesheets/index_title.xsl'))
titles = template.transform(pre)



#Combining corpus and index together
latex_file.write(latex.children.to_s)
latex_file.write(regis.children.to_s)
latex_file.write(titles.children.to_s)

#Finishing
latex_file.write("\n")
latex_file.write('\end{document}')
latex_file.close

#It is necessary to call pdflatex from the output directory
Dir.chdir "/tmp/"
cmd = 'pdflatex -interaction nonstopmode --enable-write18 -shell-escape -output-directory="." example.tex > /dev/null'
system( cmd )
puts "Ready!"
