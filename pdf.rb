require 'nokogiri'
require 'pry'

#Inputfile
doc = File.open("../mozart.xml") { |f| Nokogiri::XML(f)  }
#oc.encoding = 'utf-8'
#doc.encoding = 'ASCII'

#Preprocessing
preprocessing_file=File.new('/tmp/preprocessing.xml', 'w')
latex_file=File.new('/tmp/example.tex', 'w')
preproc = Nokogiri::XSLT(File.read('stylesheets/preprocessing-de.xsl'))
preprocessing_xml = preproc.transform(doc)
preprocessing_file.write(preprocessing_xml)

#=begin
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
# this is necessary because XSLT 1.0 lacks regexp support; it can/should be called at the input.file
cmd1 = 'sed -i -E "s/\|([a-zA-Z0-9#])/\$\^\1\$/g" example.tex'
cmd2 = 'pdflatex -interaction nonstopmode --enable-write18 -shell-escape -output-directory="." example.tex > /dev/null'
cmd3 = 'rubber --pdf example'
system( cmd1 )
#system( cmd2 )
system( cmd3 )
puts "Ready!"
#=end
