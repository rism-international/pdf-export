<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:zs="http://www.loc.gov/zing/srw/" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="marc">
  <xsl:output method="text" indent="no" encoding="UTF-8" omit-xml-declaration="yes" />
  <xsl:output method="text" indent="no" encoding="UTF-8"/>
  <xsl:template match="/">
    \clearpage  
\twocolumn[{%
\centering
\LARGE Index of titles and text \\[1.5em]}] 
<xsl:for-each select="*/title">
<xsl:sort select="translate(translate(., '[]', ''), 'äöüšÄÖÜŠ', 'aousAOUS')" lang="de"/>
<xsl:if test="not(preceding-sibling::*=.)">
<xsl:text>&#xa;</xsl:text>
\newline 
<xsl:value-of select="."/><xsl:text> ..... </xsl:text><xsl:value-of select="@cat-no"/>      
</xsl:if>
<xsl:if test="preceding-sibling::*=.">
  <xsl:if test="not(preceding-sibling::*[1]/@cat-no=@cat-no)">, <xsl:value-of select="@cat-no"/>      
</xsl:if>
</xsl:if>
</xsl:for-each>
</xsl:template>
</xsl:stylesheet>
