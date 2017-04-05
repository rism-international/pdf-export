<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:zs="http://www.loc.gov/zing/srw/" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="marc">
  <xsl:output method="text" indent="no" encoding="UTF-8" omit-xml-declaration="yes" />
  <xsl:template match="/">
\documentclass[twocolumn]{book}
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
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
\fancyhead[C]{\small Répertoire International des Sources Musicales}
\renewcommand{\headrulewidth}{0.4pt}
\begin{titlepage}
\title{RISM Musical Sources}
\author{\copyright \ 2017 by \ RISM}
\date{\today}
\end{titlepage}
\begin{document}
\maketitle
\thispagestyle{empty}
\cleardoublepage
\setlength{\columnseprule}{0.5pt}
\newcommand\hfillplus[1]{{\unskip\nobreak\hfill\penalty50\
  \mbox{}\nobreak\hfill#1}}
<!--START CORPUS-->
<xsl:for-each select="document/record">
  <xsl:for-each select="para">
\newline
<xsl:for-each select="./*">
  <xsl:choose>
    <xsl:when test="name(.)='verovio-code'">
\begin{filecontents*}{<xsl:value-of select="filename"/>.code}
<xsl:value-of select="code"/>
<\end{filecontents*}
\commandline{ verovio --spacing-non-linear=0.50 --adjust-page-height -b 0 <xsl:value-of select="filename"/>.code }
\newline
\includesvg[width=350pt]{<xsl:value-of select="filename"/>}%
    </xsl:when>
    <xsl:when test="not(name(.)='verovio-code')">
      <xsl:value-of select="."/><xsl:text>  </xsl:text>
    </xsl:when>
</xsl:choose>
    </xsl:for-each>
  </xsl:for-each>
</xsl:for-each>
\end{document}
</xsl:template>
</xsl:stylesheet>
    </xsl:when>
    <xsl:when test="not(name(.)='verovio-code')">
      <xsl:value-of select="."/><xsl:text>  </xsl:text>
    </xsl:when>
</xsl:choose>
    </xsl:for-each>
  </xsl:for-each>
</xsl:for-each>
\end{document}
</xsl:template>
</xsl:stylesheet>
