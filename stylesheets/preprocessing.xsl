<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:zs="http://www.loc.gov/zing/srw/" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="marc">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  <xsl:template match="zs:searchRetrieveResponse">
    <document>
      <xsl:variable name="apos">'</xsl:variable>
      <xsl:apply-templates select="zs:records/zs:record/zs:recordData/marc:record">
        <xsl:sort select="marc:datafield[@tag=100]/marc:subfield[@code='a'] = false()"/>
        <xsl:sort select="translate(translate(marc:datafield[@tag=100]/marc:subfield[@code='a'], concat('[]', $apos), ''), 'äöüšÄÖÜŠ', 'aousAOUS')" lang="de"/>
        <xsl:sort select="translate(translate(marc:datafield[@tag=240]/marc:subfield[@code='a'], '[]',''), 'äöüšÄÖÜŠ', 'aousAOUS')" lang="de"/>
        <xsl:sort select="translate(translate(marc:datafield[@tag=130]/marc:subfield[@code='a'], '[]',''), 'äöüšÄÖÜŠ', 'aousAOUS')" lang="de"/>
     </xsl:apply-templates>
    </document>
  </xsl:template>

  <xsl:template match="zs:records/zs:record/zs:recordData/marc:record">
    <record>
      <xsl:attribute name="position"><xsl:value-of select="position()"/></xsl:attribute>
      <xsl:attribute name="rismid"><xsl:value-of select="marc:controlfield[@tag='001']"/></xsl:attribute>
      <xsl:apply-templates select="marc:datafield[@tag='100']">
        <xsl:with-param name="pos"><xsl:value-of select="position()"/></xsl:with-param>
      </xsl:apply-templates>
      <xsl:apply-templates select="marc:datafield[@tag='130']">
        <xsl:with-param name="pos"><xsl:value-of select="position()"/></xsl:with-param>
      </xsl:apply-templates>
      <xsl:apply-templates select="marc:datafield[@tag='240']"/>
      <xsl:apply-templates select="marc:datafield[@tag='245']"/>
      <xsl:apply-templates select="marc:datafield[@tag=300]/marc:subfield[@code=8]">
        <xsl:sort select="."/>
      </xsl:apply-templates>
      <xsl:apply-templates select="marc:datafield[@tag='031']">
        <xsl:with-param name="pos"><xsl:value-of select="position()"/></xsl:with-param>
      </xsl:apply-templates>
      <xsl:apply-templates select="marc:controlfield[@tag='001']"/>
      <xsl:apply-templates select="marc:datafield[@tag='500']"/>
      <xsl:apply-templates select="marc:datafield[@tag='700']">
        <xsl:sort select="."/>
        </xsl:apply-templates>
      <xsl:apply-templates select="marc:datafield[@tag='710']">
        <xsl:sort select="."/>
      </xsl:apply-templates>
 
      <xsl:apply-templates select="marc:datafield[@tag='691']"/>
      <xsl:apply-templates select="marc:datafield[@tag='852']"/>
      <xsl:apply-templates select="marc:datafield[@tag='773']"/>
    </record>
  </xsl:template>

  <xsl:template match="marc:controlfield[@tag='001']">
    <rism_id before="\newline RISM-ID: ">
      <xsl:value-of select="."/>
    </rism_id>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='100']">
    <xsl:param name="pos"/>
    <composer>
      <xsl:attribute name="before"><xsl:value-of select="concat($newline, $par, '\vspace{7pt} \textcolor{darkblue}{\textbf{')"/></xsl:attribute>
      <xsl:value-of select="marc:subfield[@code='a']"/>
      </composer>
      <life_date>
        <xsl:attribute name="after">}}</xsl:attribute>
      <xsl:value-of select="marc:subfield[@code='d']"/>
    </life_date>
    <id before="\hfillplus{{" after="}}"><xsl:value-of select="$pos"/></id>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='130']">
    <xsl:param name="pos"/>
    <composer>
      <xsl:attribute name="before"><xsl:value-of select="concat($newline, $par, '\vspace{7pt} \textcolor{darkblue}{\textbf{Collection}}')"/></xsl:attribute></composer>
    <id before="\hfillplus{{" after="}}"><xsl:value-of select="$pos"/></id>
    <uniform_title before="{$newline}">
      <xsl:value-of select="marc:subfield[@code='a']"/>
      <xsl:if test="marc:subfield[@code='k']">. <xsl:value-of select="marc:subfield[@code='k']"/></xsl:if>
      <xsl:if test="marc:subfield[@code='o']">. <xsl:value-of select="marc:subfield[@code='o']"/></xsl:if>
    </uniform_title>
    <key><xsl:value-of select="marc:subfield[@code='r']"/></key>
    <work_catalog><xsl:value-of select="marc:subfield[@code='n']"/></work_catalog> 
    <xsl:if test="marc:subfield[@code='m']">
      <scoring before="{$newline}"><xsl:value-of select="marc:subfield[@code='m']"/></scoring>
    </xsl:if>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='240']">
    <uniform_title before="\newline ">
      <xsl:value-of select="marc:subfield[@code='a']"/>
      <xsl:if test="marc:subfield[@code='k']">. <xsl:value-of select="marc:subfield[@code='k']"/></xsl:if>
      <xsl:if test="marc:subfield[@code='o']">. <xsl:value-of select="marc:subfield[@code='o']"/></xsl:if>
    </uniform_title>
    <key><xsl:value-of select="marc:subfield[@code='r']"/></key>
    <work_catalog><xsl:value-of select="marc:subfield[@code='n']"/></work_catalog>
    <xsl:if test="marc:subfield[@code='m']">
      <scoring before="{$newline}"><xsl:value-of select="marc:subfield[@code='m']"/></scoring>
    </xsl:if>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='245']">
    <original_title>
      <xsl:attribute name="before"><xsl:value-of select="concat($newline, '\begin{itshape}')"/></xsl:attribute>
      <xsl:attribute name="after"><xsl:value-of select="'\end{itshape} '"/></xsl:attribute>
      <xsl:value-of select="marc:subfield[@code='a']"/>
    </original_title>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag=300]/marc:subfield[@code=8]">
    <xsl:for-each select=".">
      <xsl:sort select="." lang="de"/>
      <xsl:variable name="layer" select="."/>
      <layer>
        <xsl:attribute name="before"><xsl:value-of select="concat($newline, '\textcolor{darkblue}{\ding{\numexpr181 + ', .,'}}')"/></xsl:attribute>
      </layer>
      <xsl:for-each select="../../marc:datafield/marc:subfield[@code=8][.=$layer]">
        <xsl:call-template name="mat" select="../../marc:datafield/marc:subfield[@code=8][.=$layer]"/>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="mat">
    <xsl:choose>
      <xsl:when test="../@tag=260">
        <xsl:call-template name="date" select="../marc:datafield"/>
        </xsl:when>
      <xsl:when test="../@tag=300">
        <xsl:call-template name="n300" select="../marc:datafield"/>
      </xsl:when>
      <xsl:when test="../@tag=593">
        <xsl:call-template name="copystatus" select="../marc:datafield"/>
        </xsl:when> 
      <xsl:when test="../@tag=592">
        <xsl:call-template name="watermark" select="../marc:datafield"/>
      </xsl:when>
      <xsl:when test="../@tag=700">
        <xsl:call-template name="copyist" select="../marc:datafield"/>
      </xsl:when>
      <xsl:when test="../@tag=500">
        <xsl:call-template name="material-note" select="../marc:datafield"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="date">
    <date>
      <xsl:value-of select="../marc:subfield[@code='c']"/>
    </date>
  </xsl:template>

  <xsl:template name="copystatus">
    <copystatus before="{$newline}">
      <xsl:value-of select="../marc:subfield[@code='a']"/>
    </copystatus>
  </xsl:template>

  <xsl:template name="n300">
    <score>
      <xsl:value-of select="../marc:subfield[@code='a']"/>
    </score>
    <format>
      <xsl:value-of select="../marc:subfield[@code='c']"/>
    </format>
  </xsl:template>

  <xsl:template name="copyist">
    <copyist>
      <xsl:attribute name="before"><xsl:value-of select="$newline"/></xsl:attribute>
      <xsl:value-of select="../marc:subfield[@code='a']"/>
    </copyist>
  </xsl:template>

  <xsl:template name="watermark">
    <watermark>
      <xsl:if test="../preceding-sibling::*[1]/@tag!=../@tag">
        <xsl:attribute name="before"><xsl:value-of select="concat($newline, 'Watermark: ')"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="../preceding-sibling::*[1]/@tag=../@tag">
        <xsl:attribute name="before">; </xsl:attribute>
      </xsl:if>
      <xsl:value-of select="../marc:subfield[@code='a']"/>
    </watermark>
  </xsl:template>

  <xsl:template name="material-note">
    <material-note>
      <xsl:attribute name="before"><xsl:value-of select="concat($newline, '\begin{small} ')"/></xsl:attribute>
      <xsl:attribute name="after"><xsl:value-of select="'\end{small} '"/></xsl:attribute>
      <xsl:value-of select="../marc:subfield[@code='a']"/>
    </material-note>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='031']">
    <xsl:param name="pos"/>
    <no before="\newline ">
      <xsl:value-of select="marc:subfield[@code='a']"/>.<xsl:value-of select="marc:subfield[@code='b']"/>.<xsl:value-of select="marc:subfield[@code='c']"/>
    </no>
    <xsl:if test="marc:subfield[@code='m']"> 
      <inc_score><xsl:value-of select="marc:subfield[@code='m']"/></inc_score>
    </xsl:if>
    <xsl:if test="marc:subfield[@code='r']"> 
      <inc_key><xsl:value-of select="marc:subfield[@code='r']"/></inc_key>
    </xsl:if>
    <xsl:if test="marc:subfield[@code='t']"> 
      <text before="\newline \begin{{footnotesize}} " after=" \end{{footnotesize}}" ><xsl:value-of select="marc:subfield[@code='t']"/></text>
    </xsl:if>
    <xsl:if test="marc:subfield[@code='p']">
      <verovio-code>
        <filename><xsl:value-of select="concat($pos,'-',position())"/></filename>
        <code>@clef:<xsl:value-of select="marc:subfield[@code='g']"/>
@keysig:<xsl:value-of select="marc:subfield[@code='n']"/>
@timesig:<xsl:value-of select="marc:subfield[@code='o']"/>
@data:<xsl:value-of select="marc:subfield[@code='p']"/>
        </code>
      </verovio-code>
    </xsl:if>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='500']">
    <xsl:choose>
      <xsl:when test="marc:subfield[@code=8]"/>
      <xsl:when test="not(marc:subfield[@code=8])">
        <note><xsl:attribute name="before"><xsl:value-of select="$newline"/></xsl:attribute>
          <xsl:value-of select="marc:subfield[@code='a']"/>
        </note>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
 
  <xsl:template match="marc:datafield[@tag='700']">
    <xsl:choose>
      <xsl:when test="marc:subfield[@code=8]"/>
      <xsl:when test="not(marc:subfield[@code=8])">
        <name before="\newline "><xsl:value-of select="marc:subfield[@code='a']"/></name>
        <func>(<xsl:value-of select="marc:subfield[@code=4]"/>)</func>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='710']">
    <xsl:choose>
      <xsl:when test="marc:subfield[@code=8]"/>
      <xsl:when test="not(marc:subfield[@code=8])">
        <institution before="\newline "><xsl:value-of select="marc:subfield[@code='a']"/></institution>
        <func>(<xsl:value-of select="marc:subfield[@code=4]"/>)</func>
      </xsl:when>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="marc:datafield[@tag=691]">
    <xsl:choose>
      <xsl:when test="position()=1">
        <lit before="\newline Literature: "><xsl:value-of select="marc:subfield[@code='a']"/></lit>
        <page><xsl:value-of select="marc:subfield[@code='n']"/></page>
      </xsl:when>
      <xsl:when test="not(position()=1)">
        <lit before="; "><xsl:value-of select="marc:subfield[@code='a']"/></lit>
        <page><xsl:value-of select="marc:subfield[@code='n']"/></page>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='852']">
    <library>
      <xsl:if test="position()=1">
        <xsl:attribute name="before"><xsl:value-of select="$newline"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="position()!=1">
        <xsl:attribute name="before">; </xsl:attribute>
      </xsl:if>
      <xsl:value-of select="marc:subfield[@code='a']"/></library>
    <xsl:if test="marc:subfield[@code='c']">
      <shelfmark><xsl:value-of select="marc:subfield[@code='c']"/></shelfmark>
    </xsl:if>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='773']">
    <collection-link before="{$newline}">
      <xsl:value-of select="marc:subfield[@code='w']"/>
    </collection-link>
  </xsl:template>


  <xsl:variable name="newline">\newline </xsl:variable>
  <xsl:variable name="par">\par </xsl:variable>

</xsl:stylesheet>
