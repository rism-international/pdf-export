<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:zs="http://www.loc.gov/zing/srw/" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="marc">
  <xsl:output method="text" indent="no" encoding="UTF-8" omit-xml-declaration="yes" />
  <xsl:key name="collection" match="record" use="@rismid"/>
  <xsl:template match="/">
\documentclass[twocolumn]{book}
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
\makeatletter
\let\latexl@section\l@section
\def\l@section#1#2{\begingroup\let\numberline\@gobble\latexl@section{#1}{#2}\endgroup}
\makeatother
\begin{titlepage}
\title{RISM Musical Sources}
\author{\copyright \ 2017 by \ RISM}
\date{\today}
\end{titlepage}
\begin{document}
\maketitle
\thispagestyle{empty}
\renewcommand*\contentsname{\hfill Table of content \hfill}
\tableofcontents
\thispagestyle{empty}
\cleardoublepage
\setlength{\columnseprule}{0.5pt}
\newcommand\hfillplus[1]{{\unskip\nobreak\hfill\penalty50\
  \mbox{}\nobreak\hfill#1}}
\newcommand\invisiblesection[1]{%
  \refstepcounter{section}%
  \addcontentsline{toc}{section}{\protect\numberline{\thesection}#1}%
  \sectionmark{#1}}
<!--START CORPUS-->
\setcounter{secnumdepth}{0}
\invisiblesection{Catalog of musical sources}
\fancyhead{}
\fancyhead[C]{\small Répertoire International des Sources Musicales}
\twocolumn[{%
\centering
\LARGE Catalog of musical sources \\[1.5em]}] 
<xsl:for-each select="document/record">
<xsl:for-each select="./*">
<xsl:if test="starts-with(@pre, '\newline')">
<xsl:text>&#xa;</xsl:text>
</xsl:if>

<xsl:value-of select="@pre"/>
<xsl:choose>
<xsl:when test="name(.)='verovio-code'">
\begin{filecontents*}{<xsl:value-of select="filename"/>.code}
<xsl:value-of select="code"/>
\end{filecontents*}
\commandline{ verovio --spacing-non-linear=0.50 -w 1500 --spacing-system=0.5 --adjust-page-height -b 0 <xsl:value-of select="filename"/>.code }
\newline
\includesvg[width=220pt]{<xsl:value-of select="filename"/>}%</xsl:when>
<xsl:when test="not(name(.)='verovio-code')">
<xsl:choose>
<xsl:when test="not(name(.)='collection-link')">
<xsl:value-of select="."/><xsl:text>  </xsl:text>
</xsl:when>
<xsl:when test="name(.)='collection-link'">
<xsl:variable name="coll" select="."/>
<xsl:for-each select="key('collection',$coll)">$\rightarrow$ In collection cat. no. <xsl:value-of select="@position"/> (<xsl:value-of select="@rismid"/>)
</xsl:for-each>
</xsl:when>
</xsl:choose>
</xsl:when>
</xsl:choose>
<xsl:value-of select="@post"/>
</xsl:for-each>
</xsl:for-each>
<!-- \end{document} -->
</xsl:template>
</xsl:stylesheet>
