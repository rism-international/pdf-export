<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:zs="http://www.loc.gov/zing/srw/" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="marc">
  <xsl:output method="text" indent="yes" encoding="UTF-8" omit-xml-declaration="yes" />
	<xsl:template match="zs:searchRetrieveResponse">
\documentclass[twocolumn]{book}
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
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
<xsl:for-each select="zs:records/zs:record/zs:recordData/marc:record">
  
  <xsl:sort select="marc:datafield[@tag=100]/marc:subfield[@code='a']" lang="de"/>
<xsl:sort select="marc:datafield[@tag=240]/marc:subfield[@code='a']" lang="de"/>

<xsl:variable name="counter" select="position()" />
<xsl:variable name="creator" select="marc:datafield[@tag=100]/marc:subfield[@code='a']"/>
<xsl:variable name="creator_date" select="marc:datafield[@tag=100]/marc:subfield[@code='d']"/>

<!--AUTHOR-->
%creator:::<xsl:value-of select="$creator"/>:::<xsl:value-of select="$counter" />
\newline \textcolor{darkblue}{\textbf{<xsl:value-of select="$creator"/>
<xsl:if test="$creator_date"> (<xsl:value-of select="$creator_date"/>)</xsl:if>}}\hfillplus{<xsl:value-of select="$counter" />}
<!--TITLE-->
<xsl:for-each select="marc:datafield[@tag=240]">
<xsl:text>
\newline </xsl:text>
<xsl:value-of select="marc:subfield[@code='a']"/></xsl:for-each>
<xsl:for-each select="marc:datafield[@tag=240]/marc:subfield[@code='r']"> - <xsl:value-of select="."/></xsl:for-each>
<xsl:for-each select="marc:datafield[@tag=240]/marc:subfield[@code='m']"><xsl:text>
\newline </xsl:text><xsl:value-of select="."/></xsl:for-each>
<xsl:text>
\newline </xsl:text>
<xsl:for-each select="marc:datafield[@tag=245]/marc:subfield[@code='a']">\itshape <xsl:value-of select="."/> \normalfont </xsl:for-each>
<!--LYR-->
<xsl:if test="marc:datafield[@tag=700]/marc:subfield[@code='4']='lyr'">
<xsl:text>
\newline Text: </xsl:text>
</xsl:if>
<xsl:for-each select="marc:datafield[@tag=700]">
<xsl:if test="marc:subfield[@code='4']='lyr'">
<xsl:for-each select="marc:subfield[@code='a']">
<xsl:value-of select="." />
<xsl:text>; </xsl:text>
</xsl:for-each>
</xsl:if>
</xsl:for-each>
<!--MATERIAL-->
<xsl:for-each select="marc:datafield[@tag=593]">
<xsl:variable name="material" select="marc:subfield[@code='8']" />
<xsl:if test="$material='01'">	
<xsl:text>
\newline </xsl:text>\textcolor{darkblue}{\ding{182}} <xsl:value-of select="marc:subfield[@code='a']"/>
</xsl:if>
</xsl:for-each>
<xsl:for-each select="marc:datafield[@tag=260]">
<xsl:variable name="material" select="marc:subfield[@code='8']" />
<xsl:if test="$material='01'"><xsl:text> </xsl:text>	
<xsl:value-of select="marc:subfield[@code='c']"/>
</xsl:if>
</xsl:for-each>
<xsl:for-each select="marc:datafield[@tag=500]">
<xsl:variable name="material" select="marc:subfield[@code='8']" />
<xsl:if test="$material='01'"><xsl:text> [</xsl:text>	
<xsl:value-of select="marc:subfield[@code='a']"/><xsl:text>]</xsl:text>
</xsl:if>
</xsl:for-each>
<xsl:for-each select="marc:datafield[@tag=593]">
<xsl:variable name="material" select="marc:subfield[@code='8']" />
<xsl:if test="$material='02'">	
<xsl:text>
\newline </xsl:text>\textcolor{darkblue}{\ding{183}} <xsl:value-of select="marc:subfield[@code='a']"/>
</xsl:if>
</xsl:for-each>
<xsl:for-each select="marc:datafield[@tag=260]">
<xsl:variable name="material" select="marc:subfield[@code='8']" />
<xsl:if test="$material='02'"><xsl:text> </xsl:text>	
<xsl:value-of select="marc:subfield[@code='c']"/>
</xsl:if>
</xsl:for-each>
<!--INCIPIT-->
<xsl:for-each select="marc:datafield[@tag=031]"><xsl:variable name="incno" select="position()" />
\newline	
<xsl:value-of select="marc:subfield[@code='a']"/>.<xsl:value-of select="marc:subfield[@code='b']"/>.<xsl:value-of select="marc:subfield[@code='c']"/>
<xsl:for-each select="marc:subfield[@code='m']">
<xsl:text> </xsl:text>
<xsl:value-of select="."/>
</xsl:for-each>
<xsl:for-each select="marc:subfield[@code='t']">
<xsl:text>, </xsl:text>
<xsl:value-of select="."/>
</xsl:for-each>
<xsl:for-each select="marc:subfield[@code='p']">
<!--
  <xsl:text> (</xsl:text>
  <xsl:for-each select="marc:subfield[@code='o']">
  <xsl:value-of select="."/>
  </xsl:for-each>
  <xsl:for-each select="marc:subfield[@code='g']">
  <xsl:text>, </xsl:text>
  <xsl:value-of select="."/>
  </xsl:for-each>
  <xsl:for-each select="marc:subfield[@code='r']">
  <xsl:text>, </xsl:text>
  <xsl:value-of select="."/>
  </xsl:for-each>
  <xsl:text>)</xsl:text>
-->
\newline
\begin{filecontents*}{<xsl:value-of select="concat($counter,'-',$incno)"/>.txt}<xsl:variable name="clef" select="../marc:subfield[@code='g']" />
<xsl:variable name="key" select="../marc:subfield[@code='n']"/>
<xsl:variable name="meter" select="../marc:subfield[@code='o']" />
<xsl:variable name="pe" select="../marc:subfield[@code='p']"/>
@clef:<xsl:value-of select="$clef"/>
@keysig:<xsl:value-of select="$key"/>
@timesig:<xsl:value-of select="$meter"/>
@data:<xsl:value-of select="$pe"/>
\end{filecontents*}
\immediate\write18{ verovio --spacing-non-linear=0.50 --adjust-page-height -b 0 <xsl:value-of select="concat($counter,'-',$incno)"/>.txt }
\includesvg[width=350pt]{<xsl:value-of select="concat($counter,'-',$incno)"/>}%</xsl:for-each></xsl:for-each>
<!--REMARK -->
<xsl:for-each select="marc:datafield[@tag=500]">
<xsl:if test="not(marc:subfield[@code='8'])">
<xsl:text>
\newline </xsl:text>	
<xsl:value-of select="marc:subfield[@code='a']"/>
</xsl:if>
</xsl:for-each>
<!--SCORING -->
<xsl:for-each select="marc:datafield[@tag=594]/marc:subfield[@code='a']">
<xsl:text>
\newline </xsl:text>	
<xsl:value-of select="."/>
</xsl:for-each>
<!--RISMID-->
<xsl:text>
\newline </xsl:text>
<xsl:for-each select="marc:controlfield[@tag=001]">A/II: <xsl:value-of select="."/></xsl:for-each>
<!--SIGLA-->
<xsl:text>
\newline </xsl:text>
<xsl:for-each select="marc:datafield[@tag=852]"><xsl:value-of select="marc:subfield[@code='a']"/><xsl:text> </xsl:text><xsl:value-of select="marc:subfield[@code='c']"/></xsl:for-each>
<xsl:text>
\newline 
</xsl:text>
</xsl:for-each>
\end{document}
</xsl:template>
</xsl:stylesheet>
