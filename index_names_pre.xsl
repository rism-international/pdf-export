<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:zs="http://www.loc.gov/zing/srw/" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="marc">
  <xsl:output method="xml" encoding="UTF-8"/>
  <xsl:key name="collection" match="record" use="@rismid"/>
  
<xsl:template match="node()|@*">
  <xsl:copy>
    <xsl:apply-templates select="node()|@*"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="/">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="record">
  <xsl:for-each select="composer | name">
    <xsl:if test=".!=''">
      <person><xsl:attribute name="cat-no"><xsl:value-of select="../id"/></xsl:attribute><xsl:value-of select="."/></person>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

<xsl:template match=
  "text()[not(string-length(normalize-space()))]"/>

<xsl:template match=
  "text()[string-length(normalize-space()) > 0]">
    <xsl:value-of select="translate(.,'&#xA;&#xD;', '  ')"/>
  </xsl:template>

</xsl:stylesheet>
