require 'nokogiri'
require 'pry'

lang = YAML.load_file("locales/de.yml")
#Inputfile
input_doc = File.open("../mozart.xml") { |f| Nokogiri::XML(f)  }

input_doc.xpath("//marc:datafield[@tag='240']/marc:subfield[@code='r']").each do |n|
  if lang['n240r'][n.content]
    n.content = lang['n240r'][n.content]
  end
end
input_doc.xpath("//marc:datafield[@tag='031']/marc:subfield[@code='r']").each do |n|
  if lang['n240r'][n.content]
    n.content = lang['n240r'][n.content]
  end
end
input_doc.xpath("//marc:datafield[@tag='240']/marc:subfield[@code='k']").each do |n|
  if lang['n240k'][n.content]
    n.content = lang['n240k'][n.content]
  end
end
input_doc.xpath("//marc:datafield[@tag='240']/marc:subfield[@code='a']").each do |n|
  lang['n240a'].each do |k,v|
    if n.content.include?(k)
      n.content = n.content.gsub(k,v)
    end
  end
end
input_doc.xpath("//marc:datafield[@tag='240']/marc:subfield[@code='a']").each do |n|
  lang['n240a'].each do |k,v|
    if n.content.include?(k)
      n.content = n.content.gsub(k,v)
    end
  end
end
input_doc.xpath("//marc:datafield[@tag='300']/marc:subfield[@code='a']").each do |n|
  lang['n300a'].each do |k,v|
    if n.content.include?(k)
      n.content = n.content.gsub(k,v)
    end
  end
end
input_doc.xpath("//marc:datafield[@tag='593']/marc:subfield[@code='a']").each do |n|
  lang['n593a'].each do |k,v|
    if n.content.include?(k)
      n.content = n.content.gsub(k,v)
    end
  end
end

doc = input_doc

#Preprocessing
preprocessing_file=File.new('/tmp/preprocessing.xml', 'w')
latex_file=File.new('/tmp/example.tex', 'w')
preproc = Nokogiri::XSLT(File.read('locales/de/preprocessing.xsl'))
preprocessing_xml = preproc.transform(doc)
preprocessing_file.write(preprocessing_xml)

#=begin
#Creating the corpus
template = Nokogiri::XSLT(File.read('locales/de/latex.xsl'))
latex = template.transform(preprocessing_xml)

#Creating the people index
template = Nokogiri::XSLT(File.read('locales/de/index_names_pre.xsl'))
pre = template.transform(preprocessing_xml)

regfile = File.new("/tmp/names.xml", "w")
regfile.write(pre)

template = Nokogiri::XSLT(File.read('locales/de/index_names.xsl'))
regis = template.transform(pre)

#Creating the title index
template = Nokogiri::XSLT(File.read('locales/de/index_title_pre.xsl'))
pre = template.transform(preprocessing_xml)
template = Nokogiri::XSLT(File.read('locales/de/index_title.xsl'))
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
