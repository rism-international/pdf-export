Description
===========
<img align="right" width="25%" height="25%" style="border:3 solid black" src="example/example.png">

This software transforms a SRU-query from muscat.rism.info/sru/sources into a high quality PDF, provided by LaTex and XSLT 1.0.

Features
--------
* Integrated SVG of musical incipits generated by verovio.
* Sorting by different categories.
* Included alphabetic index and list of literature abbreviations.
* Configurable with XSLT preprocessing.
* Multilanguage support (currently english and german)
* Optional font selection
* Cross-platform support (tested with Linux and MS Windows 10)

Installation
============

Overall Requirements
--------------------
* Ruby (version >= 2.1 <= 2.4) 
* TeX Live 2016
* Inkscape (version >= 0.91)
* Verovio notation engraving library (binary executable)

If compiling of the C++ executable of Verovio is not possible you can build the SVG images of the incipits with the Verovio javascript library and the calling nodejs script, see the verovio-node subfolder. For this it needs
* Nodejs (version >= 6.10)

Installation on Linux
-----------------------
Packages and required software:

1. Ruby >= v2.1.1 
```bash
sudo apt install ruby ruby-dev
```
2. TeX Live 2016 (Latex, LuaLaTex and all included packages)
see: 
```bash
sudo add-apt-repository ppa:jonathonf/texlive-2016
sudo apt update
sudo apt install tex-common texlive-base texlive-binaries texlive-extra-utils texlive-font-utils texlive-fonts-recommended texlive-generic-recommended texlive-latex-base texlive-latex-extra texlive-latex-recommended texlive-pictures texlive-pstricks texlive-lang-german sed texlive-fonts-extra texlive-lang-greek texlive-xetex texlive-luatex
```
3. Inkscape
```bash
sudo apt install inkscape 
```
4. Verovio (called from commandline)
After downloading the Verovio source code build the executable, see: https://github.com/rism-ch/verovio/wiki/Building-instructions
```bash
$ cd tools
$ cmake . -DNO_PAE_SUPPORT=OFF
$ make
$ sudo make install
```

5. Set ulimit
For using lualatex set new size of opening files is required:
```bash
ulimit –n 64000
```
Installation on Windows 10
--------------------------
1. Install Ruby (2.3 version)
 Use the http://rubyinstaller.org/downloads/ 
 *IMPORTANT: select "add to path" during installation.*

After this open a command line window and execute:
```bash
gem install bundler
```
2. Install TeX Live 2016
https://www.tug.org/texlive/acquire-netinstall.html
(4 GB)
Hint: to find the actual temp-folder (target of the processing) insert '%temp%' in the bottom search field.

3. Install Inkscape
https://inkscape.org/en/download/
Note that path should be c:/Program Files/Inkscape

4. Install Nodejs
See https://nodejs.org/en/download/


Install the PDF-exporter
--------
* Clone this repository...
```bash
git clone https://github.com/rism-international/pdf-export.git
```
* Bundle: ...then install the needed ruby libraries from within the cloned repository ...

```bash
cd pdf-export
bundle install
```
If you need nodejs support for Verovio execute in the verovio-node subfolder:
```bash
npm install
```

* Test: ...test if everything works
```bash
 ruby pdf.rb --lang="de" --outfile="coburg.pdf" --infile="example/example.xml" --title="Kunstsammlungen der Veste Coburg" --font="serif"
```
* Enjoy!

TeX-Server
======
It's possible to execute all textprocessing on a remote host. To start LaTeX server on the remote host execute 
```bash
 tex-server/nodejs server.js
```

The remote server will listening on \:33123/tex for incoming requests then.

On the client with using the -h flag you can define the remote server;  it returns a http-response with a link for the pdf document, eg:
```bash
 ruby pdf.rb --lang="de" --infile="example/example.xml" --title="Kunstsammlungen der Veste Coburg" --font="serif" -h "http://example.org:33123/tex"
```

Background
==========


Please consider also generating more input files using the [sru-downloader](https://github.com/rism-international/sru-downloader) in the related repository.
```bash
java -jar SRUDownloader.jar "http://beta.rism.info/sru/sources?operation=searchRetrieve&version=1.1&query=possessingInstitution=D-Cv&maximumRecords=100"
```

Keep in mind that the ruby script is only a wrapper for calling all the XSLT and can be easily replaced by other program languages.

All temporary files are build in /tmp/.

Language support
-----------------
There are multiple replacements in the MARCXML for inserting optimized values.
They are called by the according folder in the locales directory.
There are two files defining global variables in the preprocessing and in the transform:
* terms.yml: All field values for the replacement, sometimes in singular and plural form.
* variables.xml: Containing variables for the XSLT.

Unicode font
-----------
Default font is Linux Libertine with coverage of Latin, Latin extented, Cyrillic, Greek und Hebrew (ca. 2000 chars). Keep in mind that no actual font covers the complete unicode range.
_Unicode characters which are not supported by the font may vanish silently._
 
For additional Unicode ranges select your font manually.


Processing
-----------
1. Preprocessing
At first the marcxml-file is transformed to a preprocessing xml, which is later used for building the PDF as well as the indices. Every node could have to attributes:
* before: LaTex-code inserted before the node content
* after: appended LaTex-content to the node content

2. XSLT

This process is called from the pdf.rb-script. Main target of the script is the build of a related .TEX-file using the preprocessing file. At the current state the XSLT also defines the order of the resulting document.

3. PDFtex

During the next step the .TEX-file is calling some subroutines:
* Creating textfiles with the Plaine & Easy-code.
* Calling verovio in the subshell to generate the SVG-files.
* Calling \includesvg to insert the graphics into the document.
* Completing the PDF-export.
* Generate the indices.

Hint: The pdftex-command MUST be called from within the output-directory (eg. /tmp/)

Output
------
Result will be look alike example.pdf in this repository.

Indices
-------
Indices can be build also by using the preprocessing and transforming via XSLT. Currently the index of personal names and title/text is incuded in the corpus.

Additional indices could be:
* Watermark
* Shelfmark

For implementation see the example code.

Localization
--------------

If you like to modify the values of some fields (e.g. to have a special localized version), consider using the help of related software (e.g. Nokogiri with ruby).

Performance-example
------------
This software is tested with a set of 20.100 records (query for 'bach'). With a slightly actual machine it takes
* 4 minutes to create the latex file incl. localization
* 120 minutes to build 20.700 SVG files with Verovio binary executable
* 10 minutes to compile the luatex pdf.

Result is a 142MB PDF-file with 5.700 pages.
