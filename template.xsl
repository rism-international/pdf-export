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
          <para style="bold" class="composer">
            <composer><xsl:value-of select="marc:datafield[@tag=100]/marc:subfield[@code='a']"/></composer>
            <life_date><xsl:value-of select="marc:datafield[@tag=100]/marc:subfield[@code='d']"/></life_date>
            <id sep="hfill"><xsl:value-of select="position()"/></id>
          </para>
          <para class="title">
            <uniform_title><xsl:value-of select="marc:datafield[@tag=240]/marc:subfield[@code='a']"/></uniform_title>
            <key sep=" - "><xsl:value-of select="marc:datafield[@tag=240]/marc:subfield[@code='r']"/></key>
            <work_catalog><xsl:value-of select="marc:datafield[@tag=240]/marc:subfield[@code='n']"/></work_catalog>
          </para>
          <para class="scoring">
            <scoring><xsl:value-of select="marc:datafield[@tag=240]/marc:subfield[@code='m']"/></scoring>
          </para>
          <para style="it" class="original_title">
            <original_title><xsl:value-of select="marc:datafield[@tag=245]/marc:subfield[@code='a']"/></original_title>
          </para>
          <xsl:for-each select="marc:datafield[@tag=300]/marc:subfield[@code=8]">
            <xsl:sort select="." lang="de"/>
              <xsl:variable name="layer" select="."/>
              <para class="material">
                  <layer style="bullet"><xsl:value-of select="$layer"/></layer>
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
              </para>
          </xsl:for-each>
          <xsl:for-each select="marc:datafield[@tag=031]"><xsl:variable name="incno" select="position()" />
          <para class="incipit">
                <no>
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
                    <code>@clef:<xsl:value-of select="marc:subfield[@code='g']"/>\n@keysig:<xsl:value-of select="marc:subfield[@code='n']"/>\n@timesig:<xsl:value-of select="marc:subfield[@code='o']"/>\n@data:<xsl:value-of select="marc:subfield[@code='p']"/>
</code>
                  </verovio-code>
                </xsl:if>
                <xsl:if test="marc:subfield[@code='t']"> 
                  <text style="tiny"><xsl:value-of select="marc:subfield[@code='t']"/></text>
                </xsl:if>
            </para>
        </xsl:for-each>
        <xsl:for-each select="marc:datafield[@tag=500]">
          <para class="note">
            <note><xsl:value-of select="marc:subfield[@code='a']"/></note>
          </para>
        </xsl:for-each>
        <para class="id">
          <rism_id><xsl:value-of select="marc:controlfield[@tag=001]"/></rism_id>
        </para>
        <para class="people">
          <people>
            <xsl:for-each select="marc:datafield[@tag=700]">
              <xsl:if test="not(marc:subfield[@code='8'])">
            <person>
              <func><xsl:value-of select="marc:subfield[@code='4']"/></func>
              <name><xsl:value-of select="marc:subfield[@code='a']"/></name>
            </person>
          </xsl:if>
        </xsl:for-each>
      </people>
        </para>
        <para class="siglum">
          <sigla>
            <xsl:for-each select="marc:datafield[@tag=852]">
              <siglum>
                <library><xsl:value-of select="marc:subfield[@code='a']"/></library>
                <shelfmark><xsl:value-of select="marc:subfield[@code='c']"/></shelfmark>
              </siglum>
            </xsl:for-each>
          </sigla>
        </para>
          <!--      lyric 700
          watermarks 596$a
          collection_link 773$w
          -->
        </record>
      </document>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
