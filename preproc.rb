require 'nokogiri'
require 'pry'
template_file=File.new('/tmp/template.xml', 'w')
doc = File.open("dnla.xml") { |f| Nokogiri::XML(f)  }
doc.encoding = 'utf-8'
preproc = Nokogiri::XSLT(File.read('template.xsl'))
template_xml = preproc.transform(doc)
template_file.write(template_xml)
puts "Ready!"
