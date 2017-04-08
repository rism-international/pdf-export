<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:zs="http://www.loc.gov/zing/srw/" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="marc">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  <xsl:template match="zs:searchRetrieveResponse">

    <document>
      <xsl:for-each select="zs:records/zs:record/zs:recordData/marc:record">
        <xsl:sort select="marc:datafield[@tag=100]/marc:subfield[@code='a']" lang="de"/>
        <xsl:sort select="marc:datafield[@tag=240]/marc:subfield[@code='a']" lang="de"/>
        <xsl:variable name="counter" select="position()" />
        <record>
          <composer pre="\newline \textcolor{{darkblue}}{{\textbf{{"><xsl:value-of select="marc:datafield[@tag=100]/marc:subfield[@code='a']"/></composer>
          <life_date post="}}}}"><xsl:value-of select="marc:datafield[@tag=100]/marc:subfield[@code='d']"/></life_date>
          <id pre="\hfillplus{{" post="}}"><xsl:value-of select="position()"/></id>
            <uniform_title pre="\newline "><xsl:value-of select="marc:datafield[@tag=240]/marc:subfield[@code='a']"/></uniform_title>
            <key sep=" - "><xsl:value-of select="marc:datafield[@tag=240]/marc:subfield[@code='r']"/></key>
            <work_catalog><xsl:value-of select="marc:datafield[@tag=240]/marc:subfield[@code='n']"/></work_catalog>
            <scoring pre="\newline "><xsl:value-of select="marc:datafield[@tag=240]/marc:subfield[@code='m']"/></scoring>
            <original_title pre="\newline \begin{{itshape}}" post="\end{{itshape}}"><xsl:value-of select="marc:datafield[@tag=245]/marc:subfield[@code='a']"/></original_title>
          <xsl:for-each select="marc:datafield[@tag=300]/marc:subfield[@code=8]">
            <xsl:sort select="." lang="de"/>
              <xsl:variable name="layer" select="."/>
                  <layer style="bullet" pre="\newline "><xsl:value-of select="$layer"/></layer>
                  <xsl:for-each select="../../marc:datafield/marc:subfield[@code=8][.=$layer]">
                    <xsl:if test="../@tag=260">
                      <date><xsl:value-of select="../marc:subfield[@code='c']"/></date>
                    </xsl:if>
                    <xsl:if test="../@tag=300">
                      <score><xsl:value-of select="../marc:subfield[@code='a']"/></score>
                      <format><xsl:value-of select="../marc:subfield[@code='c']"/></format>
                      </xsl:if>
                      <xsl:if test="../@tag=592">
                      <watermark><xsl:value-of select="../marc:subfield[@code='a']"/></watermark>
                    </xsl:if>
                    <xsl:if test="../@tag=700">
                      <copyist><xsl:value-of select="../marc:subfield[@code='a']"/></copyist>
                    </xsl:if>
                  </xsl:for-each>
          </xsl:for-each>
          <xsl:for-each select="marc:datafield[@tag=031]"><xsl:variable name="incno" select="position()" />
                <no pre="\newline ">
                  <xsl:value-of select="marc:subfield[@code='a']"/>.<xsl:value-of select="marc:subfield[@code='b']"/>.<xsl:value-of select="marc:subfield[@code='c']"/>
                </no>
                <xsl:if test="marc:subfield[@code='m']"> 
                  <inc_score><xsl:value-of select="marc:subfield[@code='m']"/></inc_score>
                </xsl:if>
                <xsl:if test="marc:subfield[@code='r']"> 
                  <inc_key><xsl:value-of select="marc:subfield[@code='r']"/></inc_key>
                </xsl:if>
                <xsl:if test="marc:subfield[@code='p']">
                  <verovio-code>
                    <filename><xsl:value-of select="concat($counter,'-',$incno)"/></filename>
                    <code>@clef:<xsl:value-of select="marc:subfield[@code='g']"/>
@keysig:<xsl:value-of select="marc:subfield[@code='n']"/>
@timesig:<xsl:value-of select="marc:subfield[@code='o']"/>
@data:<xsl:value-of select="marc:subfield[@code='p']"/>
</code>
                  </verovio-code>
                </xsl:if>
                <xsl:if test="marc:subfield[@code='t']"> 
                  <text style="tiny"><xsl:value-of select="marc:subfield[@code='t']"/></text>
                </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:datafield[@tag=500]">
            <note pre="\par "><xsl:value-of select="marc:subfield[@code='a']"/></note>
        </xsl:for-each>
          <rism_id pre="\newline "><xsl:value-of select="marc:controlfield[@tag=001]"/></rism_id>
            <xsl:for-each select="marc:datafield[@tag=700]">
              <xsl:if test="not(marc:subfield[@code='8'])">
            <person pre="\newline ">
              <func><xsl:value-of select="marc:subfield[@code='4']"/></func>
              <name><xsl:value-of select="marc:subfield[@code='a']"/></name>
            </person>
          </xsl:if>
        </xsl:for-each>
            <xsl:for-each select="marc:datafield[@tag=852]">
              <siglum pre="\newline " post="\newline \newline">
                <library><xsl:value-of select="marc:subfield[@code='a']"/></library>
                <shelfmark><xsl:value-of select="marc:subfield[@code='c']"/></shelfmark>
              </siglum>
            </xsl:for-each>
          <!--      lyric 700
          watermarks 596$a
          collection_link 773$w
          -->
        </record>
      </document>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
