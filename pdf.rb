require 'nokogiri'
require 'pry'
require 'trollop'
require 'yaml'
require 'tmpdir'

opts = Trollop::options do
    version "RISM PDF Catalog 1.0 (2017.04)"
      banner <<-EOS
      This utility program changes SRU-retrieve file to high quality PDF output. 
      Overall required argument is -i [inputfile].
      Usage:
         ruby pdf.rb [-iol]
         where [options] are:
      EOS
opt :lang, "Language option (currently support for english & german)", :short => '-l', :default => "en"
opt :font, "Select serif or sans font", :short => '-f', :default => "serif"
opt :clear, "Clearing temporary files before executing", :short => '-c', :type => :boolean, :default => false
opt :title, "Defines the title of the catalog", :short => '-t', :default => "RISM"
opt :outfile, "Output-Filename", :type => :string, :default => "/tmp/example.pdf", :short => '-o'
opt :infile, "Input-Filename as MarcXML", :type => :string, :short => '-i'
end

if !opts[:infile]
  Trollop::die :infile, "must exist"
  puts "argument `-i; --infile` required."
  exit
end

temp_path = Dir.tmpdir() 
prog_path = Dir.pwd
verovio_node_path = File.join(prog_path, "verovio-node", "pae.js")
platform = RbConfig::CONFIG["host_os"]
ifile=opts[:infile]
ofile=opts[:outfile]
lang=opts[:lang]
title=opts[:title]

sfont=opts[:font]
if sfont == "serif"
  font = "Linux Libertine O"
elsif sfont == "sans"
  font = "Linux Biolinum O"
else
  font = "Linux Libertine O"
end
  
varFile=File.join(prog_path, "locales", lang, "variables.xml")
termFile=File.join(prog_path, "locales", lang, "terms.yml")
terms = YAML.load_file(termFile)
doc = File.open(ifile) { |f| Nokogiri::XML(f)  }

# Replacement according the localization
#

doc.xpath("//marc:record").each do |record|
  record.xpath("marc:datafield[@tag='240' or @tag='130']/marc:subfield").each do |n|
    if n.attribute("code").value == 'a'
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
  end
end



=begin

doc.xpath("//marc:datafield[@tag='240']/marc:subfield[@code='r']").each do |n|
  if terms['n240r'][n.content]
    n.content = terms['n240r'][n.content]
  end
end

doc.xpath("//marc:datafield[@tag='031']/marc:subfield[@code='r']").each do |n|
  if terms['n240r'][n.content]
    n.content = terms['n240r'][n.content]
  end
end

if lang!='en'
  doc.xpath("//marc:datafield[@tag='240']/marc:subfield[@code='k']").each do |n|
    if terms['n240k'][n.content]
      n.content = terms['n240k'][n.content]
    end
  end
end

doc.xpath("//marc:datafield[@tag='130' or @tag='240']/marc:subfield[@code='a']").each do |n|
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
  doc.xpath("//marc:datafield[@tag='300']/marc:subfield[@code='a']").each do |n|
    terms['n300a'].each do |k,v|
      if n.content.include?(k)
        n.content = n.content.gsub(k,v)
      end
    end
  end
  doc.xpath("//marc:datafield[@tag='593']/marc:subfield[@code='a']").each do |n|
    terms['n593a'].each do |k,v|
      if n.content.include?(k)
        n.content = n.content.gsub(k,v)
      end
    end
  end
  doc.xpath("//marc:datafield[@tag='700' or @tag='710']/marc:subfield[@code='4']").each do |n|
    terms['relator_codes'].each do |k,v|
      if n.content.include?(k)
        n.content = n.content.gsub(k,v)
      end
    end
  end

end
=end
#Preprocessing
preprocessing_file=File.new(File.join(temp_path, 'preprocessing.xml'), 'w')
latex_file=File.new(File.join(temp_path, 'example.tex'), 'w:UTF-8')
preproc = Nokogiri::XSLT(File.read(File.join(prog_path, 'stylesheets', 'preprocessing.xsl')))
preprocessing_xml = preproc.transform(doc, ["varFile", "'#{varFile}'", "title", "'#{title}'"])
preprocessing_file.write(preprocessing_xml)

#Creating the corpus
template = Nokogiri::XSLT(File.read(File.join(prog_path, 'stylesheets', 'lualatex.xsl')))
latex = template.transform(preprocessing_xml, 
    ["varFile", "'#{varFile}'", 
     "title", "'#{title}'", 
     "font", "'#{font}'", 
     "platform", "'#{platform}'",
     "verovio_node_path", "'#{verovio_node_path}'"])
puts "Creation of corpus TEX file finished."

#Creating the people index
template = Nokogiri::XSLT(File.read(File.join(prog_path, 'stylesheets', 'index_names_pre.xsl')))
pre = template.transform(preprocessing_xml, ["varFile", "'#{varFile}'", "title", "'#{title}'"])
template = Nokogiri::XSLT(File.read(File.join(prog_path, 'stylesheets', 'index_names.xsl')))
regis = template.transform(pre, ["varFile", "'#{varFile}'", "title", "'#{title}'"])
puts "Creation of names index finished."

#Creating the title index
template = Nokogiri::XSLT(File.read(File.join(prog_path, 'stylesheets', 'index_title_pre.xsl')))
pre = template.transform(preprocessing_xml)
template = Nokogiri::XSLT(File.read(File.join(prog_path, 'stylesheets', 'index_title.xsl')))
titles = template.transform(pre, ["varFile", "'#{varFile}'", "title", "'#{title}'"])
puts "Creation of title index finished."

#Combining corpus and index together
latex_file.write(latex.children.to_s)
latex_file.write(regis.children.to_s)
latex_file.write(titles.children.to_s)

#Finishing
latex_file.write("\n")
latex_file.write(' \clearpage \onecolumn \ \vfill \center {\chancery Finis.}$ \vfill \thispagestyle{empty} \end{document}')
latex_file.close

#It is necessary to call pdflatex from the output directory
Dir.chdir temp_path
if opts[:clear]
  Dir.glob(File.join(temp_path, '*.svg')).each { |file| File.delete(file) }
  Dir.glob(File.join(temp_path, '*.pdf')).each { |file| File.delete(file) }
  Dir.glob(File.join(temp_path, '*.pdf_tex')).each { |file| File.delete(file) }
  Dir.glob(File.join(temp_path, '*.code')).each { |file| File.delete(file) }
end

cmd = 'lualatex -interaction batchmode --enable-write18 -shell-escape example.tex'
system( cmd )
# Run twice to have the correct TOC
puts "Compiling the TOC ..."
system( cmd )

if ofile != File.join(temp_path, "example.pdf")
  FileUtils.cp(File.join(temp_path, 'example.pdf'), File.join(File.join(prog_path, ofile)))
end
puts "Ready!"
