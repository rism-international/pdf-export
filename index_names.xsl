<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:zs="http://www.loc.gov/zing/srw/" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="marc">
  <xsl:output method="text" indent="no" encoding="UTF-8" omit-xml-declaration="yes" />
  <xsl:output method="text" indent="no" encoding="UTF-8"/>
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
\fancyhead[C]{\small Répertoire International des Sources Musicales}
\renewcommand{\headrulewidth}{0.4pt}
\begin{document}
\setlength{\columnseprule}{0.5pt}
\newcommand\hfillplus[1]{{\unskip\nobreak\hfill\penalty50\
  \mbox{}\nobreak\hfill#1}}
  
\textbf{Index of People} 
<xsl:for-each select="*/person">
<xsl:sort select="."/>
<xsl:if test="not(preceding-sibling::*=.)">
<xsl:text>&#xa;</xsl:text>
\newline 
<xsl:value-of select="."/><xsl:text> ..... </xsl:text><xsl:value-of select="@cat-no"/>      
</xsl:if>
<xsl:if test="preceding-sibling::*=.">, <xsl:value-of select="@cat-no"/>      
</xsl:if>
</xsl:for-each>
\end{document}
</xsl:template>
</xsl:stylesheet>
