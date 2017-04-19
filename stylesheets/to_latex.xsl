<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:zs="http://www.loc.gov/zing/srw/" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="marc">
  <xsl:output method="text" indent="no" encoding="UTF-8" omit-xml-declaration="yes" />
  <xsl:key name="collection" match="record" use="@rismid"/>
  <xsl:template match="/">
\documentclass[twocolumn]{book}
\usepackage[papersize={16.8cm, 25cm},left=1.5cm,right=2cm,top=2.5cm,bottom=2.5cm]{geometry}
\usepackage[utf8x]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{textcomp}
\usepackage{xparse}
\ExplSyntaxOn
\NewDocumentCommand{\commandline}{v}
  { \immediate \write 18 { \tl_to_str:n {#1}  }  }
\ExplSyntaxOff
\usepackage{graphicx}
\usepackage[inkscape={/usr/bin/inkscape -z -C }]{svg}
\usepackage{import}
\usepackage{pifont}
\usepackage{filecontents}
\usepackage[ngerman]{babel}
\usepackage{color} <!-- \usepackage{musixtex}\usepackage{harmony} -->
\usepackage{fancyhdr}
\usepackage[defaultlines=4, all]{nowidow}
\definecolor{darkblue}{rgb}{0, 0,.4}
\usepackage[colorlinks=true, urlcolor=darkblue, linkcolor=blue]{hyperref}
\usepackage[hyphens]{url}
\usepackage{csquotes}
\MakeOuterQuote{"}
\urlstyle{same}
\parindent0cm
\setlength{\columnsep}{30 pt}
\clubpenalty = 10000
\widowpenalty = 10000
\displaywidowpenalty = 10000
\tolerance=500
\let\mypdfximage\pdfximage
\protected\def\pdfximage{\immediate\mypdfximage}
\pagestyle{fancy}
\renewcommand{\headrulewidth}{0.4pt}
\begin{titlepage}
\title{RISM Musical Sources}
\author{\copyright \ 2017 by \ RISM}
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
\renewcommand*\contentsname{\hfill Table of content \hfill}
\tableofcontents
\thispagestyle{empty}
\newcommand\hfillplus[1]{{\unskip\nobreak\hfill\penalty50\
  \mbox{}\nobreak\hfill#1}}
\newcommand\invisiblesection[1]{%
  \refstepcounter{section}%
  \addcontentsline{toc}{section}{\protect\numberline{\thesection}#1}%
  \sectionmark{#1}}
<!--START CORPUS-->
\chapter*{\centering Catalog of musical sources}
\addcontentsline{toc}{chapter}{Catalog of musical sources}
\fancyhead{}
\fancyhead[C]{\small Répertoire International des Sources Musicales}
\setlength{\columnseprule}{0.5pt}
<xsl:for-each select="document/record">
<xsl:for-each select="./*">
<xsl:if test="starts-with(@before, '\newline')">
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
\commandline{ verovio --spacing-non-linear=0.50 -w 1500 --spacing-system=0.5 --adjust-page-height -b 0 <xsl:value-of select="filename"/>.code }
\newline
\includesvg[width=180pt]{<xsl:value-of select="filename"/>}%</xsl:when>
<xsl:when test="not(name(.)='verovio-code')">
  <xsl:choose>
    <xsl:when test="not(name(.)='collection-link')">
      <!-- Escaping latex entities & and muscat {{brk}} -->
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
      <xsl:value-of disable-output-escaping="yes" select="$note3"/>
    </xsl:when>
    <xsl:when test="name(.)='collection-link'">
      <xsl:variable name="coll" select="."/>
      <xsl:for-each select="key('collection',$coll)">$\rightarrow$ In collection <xsl:value-of select="@position"/> (<xsl:value-of select="@rismid"/>)
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
