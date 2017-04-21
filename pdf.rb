require 'nokogiri'
require 'pry'
require 'trollop'
require 'yaml'

opts = Trollop::options do
    version "RISM PDF Catalog 0.1 (2017.04)"
      banner <<-EOS
      This utility program changes SRU-retrieve file to high quality PDF output. 
      Overall required argument is -i [inputfile].
      Usage:
         ruby pdf.rb [-iol]
         where [options] are:
      EOS
opt :lang, "Language option (currently support for english & german)", :short => '-l', :default => "en"
opt :font, "Select the default font, for some sample see eg: https://de.sharelatex.com/learn/Font_typefaces", :short => '-f', :default => "lmodern"
opt :title, "Defines the title of the catalog", :short => '-t', :default => "RISM"
opt :fontlist, "List available fonts"
opt :outfile, "Output-Filename", :type => :string, :default => "/tmp/example.pdf", :short => '-o'
opt :infile, "Input-Filename as MarcXML", :type => :string, :short => '-i'
end

sfonts = %w(charter times lmodern ebgaramond palatino gentium LibreBodoni quattrocento gfsbodoni)
ssfonts = %w(cmbright raleway gillius gentium)

if opts[:fontlist]
  puts "Available fonts are:"
  puts "\tSerif fonts:"
  sfonts.sort.each {|e| puts "\t\t#{e}"}
  puts "\tSans Serif fonts:"
  ssfonts.sort.each {|e| puts "\t\t#{e}"}
  exit
end

if !opts[:infile]
  Trollop::die :infile, "must exist"
  puts "argument `-i; --infile` required."
  exit
end


prog_path = Dir.pwd

ifile=opts[:infile]
ofile=opts[:outfile]
lang=opts[:lang]
title=opts[:title]
font=opts[:font]
unless (sfonts + ssfonts).include?(font)
  puts "Unknown font-name, using lmodern (default latex font)."
  font = "lmodern"
end

  varFile="locales/#{lang}/variables.xml"
termFile="locales/#{lang}/terms.yml"

terms = YAML.load_file(termFile)
#Inputfile
input_doc = File.open(ifile) { |f| Nokogiri::XML(f)  }

input_doc.xpath("//marc:datafield[@tag='240']/marc:subfield[@code='r']").each do |n|
  if terms['n240r'][n.content]
    n.content = terms['n240r'][n.content]
  end
end
input_doc.xpath("//marc:datafield[@tag='031']/marc:subfield[@code='r']").each do |n|
  if terms['n240r'][n.content]
    n.content = terms['n240r'][n.content]
  end
end

if lang!='en'
  input_doc.xpath("//marc:datafield[@tag='240']/marc:subfield[@code='k']").each do |n|
    if terms['n240k'][n.content]
      n.content = terms['n240k'][n.content]
    end
  end
end

input_doc.xpath("//marc:datafield[@tag='240']/marc:subfield[@code='a']").each do |n|
  terms['n240a'].each do |k,v|
    if n.content.include?(k)
      if n.content =~ /^[0-9]/
        n.content = n.content.gsub(k,v[1])
      else
        n.content = n.content.gsub(k,v[0])
      end
    end
  end
end

if lang!='en'
  input_doc.xpath("//marc:datafield[@tag='300']/marc:subfield[@code='a']").each do |n|
    terms['n300a'].each do |k,v|
      if n.content.include?(k)
        n.content = n.content.gsub(k,v)
      end
    end
  end
  input_doc.xpath("//marc:datafield[@tag='593']/marc:subfield[@code='a']").each do |n|
    terms['n593a'].each do |k,v|
      if n.content.include?(k)
        n.content = n.content.gsub(k,v)
      end
    end
  end
end

doc = input_doc

#Preprocessing
preprocessing_file=File.new('/tmp/preprocessing.xml', 'w')
latex_file=File.new('/tmp/example.tex', 'w')
preproc = Nokogiri::XSLT(File.read('stylesheets/preprocessing.xsl'))
preprocessing_xml = preproc.transform(doc, ["varFile", "'#{varFile}'", "title", "'#{title}'"])
preprocessing_file.write(preprocessing_xml)

#Creating the corpus
template = Nokogiri::XSLT(File.read('stylesheets/latex.xsl'))
latex = template.transform(preprocessing_xml, ["varFile", "'#{varFile}'", "title", "'#{title}'", "font", "'#{font}'"])

#Creating the people index
template = Nokogiri::XSLT(File.read('stylesheets/index_names_pre.xsl'))
pre = template.transform(preprocessing_xml, ["varFile", "'#{varFile}'", "title", "'#{title}'"])

regfile = File.new("/tmp/names.xml", "w")
regfile.write(pre)

template = Nokogiri::XSLT(File.read('stylesheets/index_names.xsl'))
regis = template.transform(pre, ["varFile", "'#{varFile}'", "title", "'#{title}'"])

#Creating the title index
template = Nokogiri::XSLT(File.read('stylesheets/index_title_pre.xsl'))
pre = template.transform(preprocessing_xml)
template = Nokogiri::XSLT(File.read('stylesheets/index_title.xsl'))
titles = template.transform(pre, ["varFile", "'#{varFile}'", "title", "'#{title}'"])

#Combining corpus and index together
latex_file.write(latex.children.to_s)
latex_file.write(regis.children.to_s)
latex_file.write(titles.children.to_s)

#Finishing
latex_file.write("\n")
latex_file.write(' \clearpage \onecolumn \ \vfill \center {\chancery Finis.}$ \vfill \thispagestyle{empty} \end{document}')
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
if ofile != "/tmp/example.pdf"
  cmd4 = "cp example.pdf #{prog_path}/#{ofile}"
  system( cmd4 )
end
puts "Ready!"
