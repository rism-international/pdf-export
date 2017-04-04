<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:zs="http://www.loc.gov/zing/srw/" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="marc">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  <xsl:template match="zs:searchRetrieveResponse">


    <document>
      <xsl:for-each select="zs:records/zs:record/zs:recordData/marc:record">
        <xsl:sort select="marc:datafield[@tag=100]/marc:subfield[@code='a']" lang="de"/>
        <xsl:sort select="marc:datafield[@tag=240]/marc:subfield[@code='a']" lang="de"/>


        <record>
          <id><xsl:value-of select="position()"/></id>
          <composer><xsl:value-of select="marc:datafield[@tag=100]/marc:subfield[@code='a']"/></composer>
          <life_date><xsl:value-of select="marc:datafield[@tag=100]/marc:subfield[@code='d']"/></life_date>
          <uniform_title><xsl:value-of select="marc:datafield[@tag=240]/marc:subfield[@code='a']"/></uniform_title>
          <key><xsl:value-of select="marc:datafield[@tag=240]/marc:subfield[@code='r']"/></key>
          <scoring><xsl:value-of select="marc:datafield[@tag=240]/marc:subfield[@code='m']"/></scoring>
          <work_catalog><xsl:value-of select="marc:datafield[@tag=240]/marc:subfield[@code='n']"/></work_catalog>
          <original_title><xsl:value-of select="marc:datafield[@tag=245]/marc:subfield[@code='n']"/></original_title>


          <materials>

          <xsl:for-each select="marc:datafield/marc:subfield[@code=8]">
          <xsl:sort select="." lang="de"/>
          <xsl:variable name="layer" select="."/>
          <xsl:if test="$layer='01'"
            <material>   
              <position><xsl:value-of select="."/></position>
              <score><xsl:value-of select="../marc:subfield[@code='a']"/></score>
              <field><xsl:value-of select="../@tag"/></field>
            </material>
          </xsl:if>
          </xsl:for-each>
          </materials>

          <!--      lyric 700
          


          materials code $8

          incipits 031

          notes 500a
          watermarks 596$a

          rism_id 001
          siglum 852$a
          shelfmark 852$c
          collection_link 773$w
-->

        </record>
      </document>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
