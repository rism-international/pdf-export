<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:zs="http://www.loc.gov/zing/srw/" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="marc">
  <xsl:output method="text" indent="no" encoding="UTF-8" omit-xml-declaration="yes"/>
  <xsl:key name="collection" match="record" use="@rismid"/>
  <xsl:param name="varFile"/>
  <xsl:param name="title"/>
  <xsl:param name="font"/>
  <xsl:param name="platform"/>
  <xsl:param name="verovio_node_path"/>
  <xsl:variable name="gVariables" select="document($varFile)"/>
  
  <xsl:template match="/">
\documentclass[a4paper, twocolumn, 11pt]{book}
%\usepackage[papersize={21.0cm, 29.7cm},left=3.5cm,right=2.75cm,top=3.3cm,bottom=2.5cm]{geometry}
\usepackage{fontspec}
\usepackage[utf8]{luainputenc}
\usepackage{newunicodechar}
\setmainfont[Ligatures=TeX]{<xsl:value-of select="$font"/>}
\usepackage{luatex85}
\usepackage{shellesc}
<xsl:if test="$platform='linux-gnu'">
\usepackage{ifluatex}
\ifluatex
  \usepackage{pdftexcmds}
  \makeatletter
  \let\pdfstrcmp\pdf@strcmp
  \let\pdffilemoddate\pdf@filemoddate
  \makeatother
\fi
</xsl:if>
\usepackage{textcomp}
\usepackage{graphicx}
<xsl:choose>
  <xsl:when test="$platform='linux-gnu'">
\usepackage{float}
\newcommand{\executeiffilenewer}[3]{%
\ifnum\pdfstrcmp{\pdffilemoddate{#1}}%
{\pdffilemoddate{#2}} \gt 0
{\immediate\write18{#3}}\fi%
}
\newcommand{\includesvg}[1]{%
\executeiffilenewer{#1.svg}{#1.pdf}%
{inkscape -z -C --file=#1.svg %
--export-pdf=#1.pdf --export-latex}%
\input{#1.pdf_tex}%
}
  </xsl:when>
  <xsl:when test="$platform='mingw32'">
\usepackage{svg}
\setsvg{inkscape={"C:/Program Files/Inkscape/inkscape.exe"= -z -C}}
  </xsl:when>
</xsl:choose>
\usepackage{import}
\usepackage{pifont}
\usepackage{filecontents}
\usepackage[greek,ngerman]{babel}
\usepackage{color} <!-- \usepackage{musixtex}\usepackage{harmony} -->
\usepackage{fancyhdr}
\usepackage[defaultlines=4, all]{nowidow}
\definecolor{darkblue}{rgb}{0, 0,.4}
\usepackage[colorlinks=true, urlcolor=darkblue, linkcolor=blue]{hyperref}
\newcommand*\chancery{\fontfamily{pzc}\selectfont}
\urlstyle{same}
\parindent0cm
\setlength{\parskip}{0em}
\setlength{\columnsep}{30 pt}
\clubpenalty = 10000
\widowpenalty = 10000
\displaywidowpenalty = 10000
\tolerance=500
\pagestyle{fancy}
\begin{titlepage}
\title{<xsl:value-of select="$gVariables/*/var[@code='title']"/> \\ 
\vspace{10 mm} \large <xsl:value-of select="$title"/>
}
\author{\copyright \ RISM}
\date{\today}
\end{titlepage}
\begin{document}
\maketitle
\thispagestyle{empty}
\twocolumn[
\begin{@twocolumnfalse}
  \vspace*{250px}
  \begin{center}
    This document is licensed under the Creative Commons Attribution - ShareAlike 3.0 License. \\
    To view a copy of this license visit: \\
    \url{http://creativecommons.org/licenses/by-sa/3.0/legalcode}.
  \end{center}
\end{@twocolumnfalse}]
\renewcommand*\contentsname{\hfill <xsl:value-of select="$gVariables/*/var[@code='toc']"/> \hfill}
\tableofcontents
\thispagestyle{empty}
\newcommand\hfillplus[1]{{\unskip\nobreak\hfill\penalty50\
  \mbox{}\nobreak\hfill#1}}
<!--START CORPUS-->
\chapter*{\centering <xsl:value-of select="$gVariables/*/var[@code='title_corpus']"/>}
\addcontentsline{toc}{chapter}{<xsl:value-of select="$gVariables/*/var[@code='title_corpus']"/>}
\fancyhead{}
\fancyhead[C]{\small RISM -\ <xsl:value-of select="$title"/>}
\setlength{\columnseprule}{0.5pt}
<xsl:for-each select="document/record">
  <xsl:for-each select="./*">
<xsl:if test="starts-with(@before, '\par')">
<xsl:text>&#xa;</xsl:text>
</xsl:if>
<xsl:if test="@before">
  <xsl:value-of select="@before"/>
</xsl:if>
<xsl:if test="not(@before)">
  <xsl:text>  </xsl:text>
</xsl:if>
<xsl:choose>
<xsl:when test="name(.)='verovio-code'">
\begin{filecontents*}{<xsl:value-of select="filename"/>.code}
<xsl:value-of select="code"/>
\end{filecontents*}
<xsl:choose>
  <xsl:when test="$platform='linux-gnu'">
\ShellEscape{ if [ ! -f <xsl:value-of select="filename"/>.svg ]; then verovio --spacing-non-linear=0.54 --page-width 1500 --spacing-system=0.5 --adjust-page-height <xsl:value-of select="filename"/>.code; fi } <!-- 16.8cm, 25cm: 173pt -->
  </xsl:when>
  <xsl:when test="$platform='mingw32'">
\ShellEscape{ <xsl:value-of select="concat('If not exist ', filename, '.svg ', 'node ', $verovio_node_path, ' ', filename, '.code')"/> }
  </xsl:when>
  <xsl:otherwise>
    <xsl:message terminate="yes">ERROR Unsupported OS <xsl:value-of select="$platform"/>! Please implement the correct verovio call in lualatex.xsl below line 118 or take the java-jar version of verovio</xsl:message>
  </xsl:otherwise>
</xsl:choose>
\begin{figure}[H]
\centering
\def\svgwidth{209pt}\includesvg{"<xsl:value-of select="filename"/>"}
\end{figure}%</xsl:when>
<xsl:when test="not(name(.)='verovio-code')">
  <xsl:choose>
    <xsl:when test="name(.)='entries'">
      <xsl:value-of select="concat($gVariables/*/var[@code='contains'], ' ')"/> 
      <xsl:for-each select="entry-link">
        <xsl:sort select="key('collection', .)/@position" data-type="number"/>
        <xsl:variable name="coll" select="."/>
        <xsl:for-each select="key('collection',$coll)">
          <xsl:value-of select="@position"/>
          </xsl:for-each>
          <xsl:if test="position()!=last()">
            <xsl:text>, </xsl:text>
          </xsl:if> 
      </xsl:for-each>
    </xsl:when>
    <xsl:when test="not(name(.)='collection-link')">
      <!-- Escaping some latex entities & ~ % _ "(Quote) and muscat {{brk}} -->
      <xsl:variable name="note1">
        <xsl:call-template name="replace-string">
          <xsl:with-param name="text" select="."/>
          <xsl:with-param name="replace" select="$percent" />
          <xsl:with-param name="with" select="' \% '"/>
        </xsl:call-template>
      </xsl:variable>
     <xsl:variable name="note2">
        <xsl:call-template name="replace-string">
          <xsl:with-param name="text" select="$note1"/>
          <xsl:with-param name="replace" select="'&amp;'" />
          <xsl:with-param name="with" select="concat('\', $amp)"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="note3">
        <xsl:call-template name="replace-string">
          <xsl:with-param name="text" select="$note2"/>
          <xsl:with-param name="replace" select="'{{brk}}'" />
          <xsl:with-param name="with" select="'\newline '"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="note4">
        <xsl:call-template name="replace-string">
          <xsl:with-param name="text" select="$note3"/>
          <xsl:with-param name="replace" select="$quote" />
          <xsl:with-param name="with" select="'{\textquotedbl}'"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="note5">
        <xsl:call-template name="replace-string">
          <xsl:with-param name="text" select="$note4"/>
          <xsl:with-param name="replace" select="$underscore" />
          <xsl:with-param name="with" select="'\_'"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="note6">
        <xsl:call-template name="replace-string">
          <xsl:with-param name="text" select="$note5"/>
          <xsl:with-param name="replace" select="$flex"/>
          <xsl:with-param name="with" select="'\~'"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:value-of disable-output-escaping="yes" select="$note6"/>
    </xsl:when>
    <xsl:when test="name(.)='collection-link'">
      <xsl:variable name="coll" select="."/>
      <xsl:for-each select="key('collection',$coll)">$\rightarrow$ In <xsl:value-of select="concat($gVariables/*/var[@code='collection'], ' ')"/> <xsl:value-of select="@position"/> (<xsl:value-of select="@rismid"/>)
      </xsl:for-each>
    </xsl:when>
  </xsl:choose>
</xsl:when>
</xsl:choose>
<xsl:value-of select="@after"/>
</xsl:for-each>
</xsl:for-each>
</xsl:template>

  <xsl:variable name="quote">"</xsl:variable>
  <xsl:variable name="amp"><![CDATA[&]]></xsl:variable>
  <xsl:variable name="percent"> % </xsl:variable>
  <xsl:variable name="flex">~</xsl:variable>
  <xsl:variable name="underscore">_</xsl:variable>


  <xsl:template name="replace-string">
    <xsl:param name="text"/>
    <xsl:param name="replace"/>
    <xsl:param name="with"/>
    <xsl:choose>
      <xsl:when test="contains($text,$replace)">
        <xsl:value-of select="substring-before($text,$replace)"/>
        <xsl:value-of select="$with"/>
        <xsl:call-template name="replace-string">
          <xsl:with-param name="text"
            select="substring-after($text,$replace)"/>
          <xsl:with-param name="replace" select="$replace"/>
          <xsl:with-param name="with" select="$with"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>





</xsl:stylesheet>
