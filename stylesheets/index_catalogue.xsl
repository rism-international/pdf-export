<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:zs="http://www.loc.gov/zing/srw/" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="marc">
  <xsl:output method="text" indent="no" encoding="UTF-8" omit-xml-declaration="yes" />
  <xsl:key name="lit" match="//marc:datafield[@tag=690 or @tag=691]/marc:subfield[@code='a']" use="." />
  <xsl:variable name="codelist" select="document('utils/catalogue.xml')/collection"/>
  <xsl:param name="title"/>
  <xsl:param name="varFile"/>
  <xsl:variable name="gVariables" select="document($varFile)"/>


  <xsl:template match="/">
    \clearpage 
    \onecolumn 
    \chapter*{\centering <xsl:value-of select="$gVariables/*/var[@code='index_cat']"/>}
\addcontentsline{toc}{chapter}{<xsl:value-of select="$gVariables/*/var[@code='index_cat']"/>}
\fancyhead{}
\fancyhead[C]{\small RISM -\ <xsl:value-of select="$title"/>}

<xsl:for-each select="//marc:datafield[@tag=690 or @tag=691]/marc:subfield[generate-id() = generate-id(key('lit', .)[1])] ">
  <xsl:sort select="translate(translate(., '[]', ''), 'äöüšÄÖÜŠ', 'aousAOUS')" lang="de"/>
  \textbf{<xsl:value-of select="."/>}\hspace{10pt}
  <xsl:variable name="stitle" select="."/>

      <!-- Escaping some latex entities & ~ % _ "(Quote) and muscat {{brk}} -->
      <xsl:variable name="note1">
        <xsl:call-template name="replace-string">
          <xsl:with-param name="text" select="$codelist/cat[@code=$stitle]/text()"/>
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

      <xsl:value-of disable-output-escaping="yes" select="$note6"/> \newline 

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
