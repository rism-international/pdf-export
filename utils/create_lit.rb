require 'nokogiri'
require 'pry'
require 'yaml'
NAMESPACE={'marc' => "http://www.loc.gov/MARC21/slim"}

# This tool builds an index of RISM catalog entries
# To start use the rism_lit.xml file from the RISM open data

ofile = File.new("catalogue.xml", "w")

doc = File.open("rism_lit.xml") { |f| Nokogiri::XML(f)  }

builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
    xml.collection {
      doc.xpath("//marc:record", NAMESPACE).each do |record|
        short_title = record.xpath("marc:datafield[@tag=210]/marc:subfield[@code='a']", NAMESPACE)[0]
        if short_title
          author = record.xpath("marc:datafield[@tag=100]/marc:subfield[@code='a']", NAMESPACE).first.content + ": " rescue ""
          title = record.xpath("marc:datafield[@tag=240]/marc:subfield[@code='a']", NAMESPACE).first.content rescue ""
          place = ", " + record.xpath("marc:datafield[@tag=260]/marc:subfield[@code='a']", NAMESPACE).first.content + " " rescue ""
          year = record.xpath("marc:datafield[@tag=260]/marc:subfield[@code='c']", NAMESPACE).first.content rescue ""
          coll = ", in: " + record.xpath("marc:datafield[@tag=760]/marc:subfield[@code='t']", NAMESPACE).first.content rescue ""
          pages = ", " + record.xpath("marc:datafield[@tag=760]/marc:subfield[@code='g']", NAMESPACE).first.content rescue ""
          xml.cat (author + title + coll + pages + place + year), :code => short_title.content
        end
    end
    }
end
# If some sorting is required
=begin
result = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
  xml.collection {
  }
end
builder.doc.xpath("//cat").sort_by{|n| n.xpath("@code").text}.each do |node|
  result.doc.root << node
end
=end
ofile.write(builder.to_xml)
ofile.close
