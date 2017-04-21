<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:zs="http://www.loc.gov/zing/srw/" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="marc">
  <xsl:output method="text" indent="no" encoding="UTF-8" omit-xml-declaration="yes" />

  <xsl:param name="title"/>
  <xsl:param name="varFile"/>
  <xsl:variable name="gVariables" select="document($varFile)"/>

  <xsl:template match="/">
    \clearpage  
\chapter*{\centering <xsl:value-of select="$gVariables/*/var[@code='index_people']"/>}
\addcontentsline{toc}{chapter}{<xsl:value-of select="$gVariables/*/var[@code='index_people']"/>}
\fancyhead{}
\fancyhead[C]{\small RISM -\ <xsl:value-of select="$title"/>}
<xsl:variable name="apos">'</xsl:variable>
<xsl:for-each select="*/person">
<xsl:sort select="translate(translate(.,concat('[]',$apos), ''), 'äöüšÄÖÜŠ', 'aousAOUS')" lang="de"/>


<xsl:if test="not(preceding-sibling::*=.)">
<xsl:text>&#xa;</xsl:text>
\newline 
<xsl:value-of select="."/><xsl:text> ..... </xsl:text><xsl:value-of select="@cat-no"/>      
</xsl:if>
<xsl:if test="preceding-sibling::*=.">
  <xsl:if test="preceding-sibling::*[1]!=. or preceding-sibling::*[1]/@cat-no!=@cat-no">, <xsl:value-of select="@cat-no"/>      

</xsl:if>
</xsl:if>
</xsl:for-each>
</xsl:template>
</xsl:stylesheet>
