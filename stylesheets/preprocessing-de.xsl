<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:zs="http://www.loc.gov/zing/srw/" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="marc">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  <xsl:template match="zs:searchRetrieveResponse">
    <document>
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
      <xsl:apply-templates select="marc:datafield[@tag='500']"/>
      <xsl:apply-templates select="marc:datafield[@tag='700']">
        <xsl:sort select="."/>
        </xsl:apply-templates>
      <xsl:apply-templates select="marc:datafield[@tag='710']">
        <xsl:sort select="."/>
      </xsl:apply-templates>
 
      <xsl:apply-templates select="marc:datafield[@tag='691']"/>
      <xsl:apply-templates select="marc:datafield[@tag='852']/marc:subfield[@code='d']"/>
      <xsl:apply-templates select="marc:controlfield[@tag='001']"/>
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
      <xsl:if test="marc:subfield[@code='j']='Conjectural'">
        <xsl:attribute name="before"><xsl:value-of select="concat($newline, $par, '\vspace{7pt} \textcolor{darkblue}{\textbf{?')"/></xsl:attribute>
        <xsl:attribute name="after"><xsl:value-of select="'?'"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="marc:subfield[@code='j']!='Conjectural' or not(marc:subfield[@code='j'])">
        <xsl:attribute name="before"><xsl:value-of select="concat($newline, $par, '\vspace{7pt} \textcolor{darkblue}{\textbf{')"/></xsl:attribute>
      </xsl:if>
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
    <xsl:if test="marc:subfield[@code='n']">
      <work_catalog before=", "><xsl:value-of select="marc:subfield[@code='n']"/></work_catalog>
    </xsl:if>
    <xsl:if test="marc:subfield[@code='r']">
      <key before=" - "><xsl:value-of select="marc:subfield[@code='r']"/></key>
    </xsl:if>
    <xsl:if test="marc:subfield[@code='m']">
      <scoring before="{$newline}"><xsl:value-of select="marc:subfield[@code='m']"/></scoring>
    </xsl:if>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='240']">
    <uniform_title before="\newline ">
      <xsl:variable name="et" select="marc:subfield[@code='a']"/>
      <xsl:variable name="replace">
       <xsl:call-template name="replace-all">
          <xsl:with-param name="text" select="$et"/>
          <xsl:with-param name="array" select="$genreList" />
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="not($replace='')"><xsl:value-of select="$replace"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$et"/></xsl:otherwise>
    </xsl:choose>

      <xsl:if test="marc:subfield[@code='k']">. <xsl:value-of select="marc:subfield[@code='k']"/></xsl:if>
      <xsl:if test="marc:subfield[@code='o']">. <xsl:value-of select="marc:subfield[@code='o']"/></xsl:if>
    </uniform_title>
    <xsl:if test="marc:subfield[@code='n']">
      <work_catalog before=", "><xsl:value-of select="marc:subfield[@code='n']"/></work_catalog>
    </xsl:if>
    <xsl:if test="marc:subfield[@code='r']">
      <xsl:variable name="n240r" select="marc:subfield[@code='r']"/>
      <key before=" - "><xsl:value-of select="$keyList[@code=$n240r]"/></key>
    </xsl:if>
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
        <xsl:sort select="translate(../@tag, '3527', '1234')" order="ascending"/>
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

  <xsl:template name="parts">
    <parts before="-">
      <xsl:value-of select="../marc:subfield[@code='a']"/>
    </parts>
    <extend before=" (" after=")">
      <xsl:value-of select="../marc:subfield[@code='b']"/>
    </extend>
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
    <xsl:variable name="layer" select="../marc:subfield[@code=8]"/>
    <score>
      <xsl:value-of select="../marc:subfield[@code='a']"/>
    </score>
    <xsl:if test="../../marc:datafield[@tag='590']">
      <xsl:for-each select="../../marc:datafield[@tag='590']">
        <xsl:if test="marc:subfield[@code='8']=$layer">
          <parts before=": "><xsl:value-of select="marc:subfield[@code='a']"/></parts>
          <extend>(<xsl:value-of select="marc:subfield[@code='b']"/>)</extend>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
    <xsl:if test="../marc:subfield[@code='c']">
      <format before="; ">
        <xsl:value-of select="../marc:subfield[@code='c']"/>
      </format>
    </xsl:if>
  </xsl:template>

  <xsl:template name="copyist">
    <xsl:variable name="layer" select="../marc:subfield[@code=8]"/>
    <copyist pos="{../@tag}">
      <xsl:if test="not(../preceding-sibling::*[1]/marc:subfield[@code=8]=$layer and ../preceding-sibling::*[1]/@tag=../@tag)">
        <xsl:attribute name="before"><xsl:value-of select="concat($newline, 'Copyist: ')"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="../preceding-sibling::*[1]/marc:subfield[@code=8]=$layer and ../preceding-sibling::*[1]/@tag=../@tag">
        <xsl:attribute name="before"><xsl:value-of select="'; '"/></xsl:attribute>
      </xsl:if>
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
    <xsl:if test="marc:subfield[@code='d']"> 
      <inc_title before=", \begin{{itshape}}" after="\end{{itshape}}"><xsl:value-of select="marc:subfield[@code='d']"/></inc_title>
    </xsl:if>
 
    <xsl:if test="marc:subfield[@code='r']"> 
      <xsl:variable name="inckey" select="marc:subfield[@code='r']"/>
      <inc_key before=", "><xsl:value-of select="$keyList[@code=$inckey]"/></inc_key>
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
@data:<xsl:value-of select="marc:subfield[@code='p']"/></code></verovio-code>
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

  <xsl:template match="marc:datafield[@tag='852']/marc:subfield[@code='d']">
    <olim>
      <xsl:if test="position()=1">
        <xsl:attribute name="before"><xsl:value-of select="$newline"/>Olim: </xsl:attribute>
        </xsl:if>
        <xsl:if test="position()!=1">
        <xsl:attribute name="before">; </xsl:attribute>
      </xsl:if>
      <xsl:value-of select="."/>
    </olim>
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
  <xsl:variable name="quote">"</xsl:variable>
  <xsl:variable name="apos">'</xsl:variable>

  <xsl:param name="vkeys-de">
    <key code="C">C-Dur</key>
    <key code="C|x">Cis-Dur</key>
    <key code="C|b">Ces-Dur</key>
    <key code="D|b">Des-Dur</key>
    <key code="D">D-Dur</key>
    <key code="D|x">Dis-Dur</key>
    <key code="E|b">Es-Dur</key>
    <key code="E">E-Dur</key>
    <key code="F|b">Fes-Dur</key>
    <key code="F">F-Dur</key>
    <key code="F|x">Fis-Dur</key>
    <key code="G|b">Ges-Dur</key>
    <key code="G">G-Dur</key>
    <key code="G|x">Gis-Dur</key>
    <key code="A|b">As-Dur</key>
    <key code="A">A-Dur</key>
    <key code="A|x">Ais-Dur</key>
    <key code="B|b">B-Dur</key>
    <key code="B">H-Dur</key>
    <key code="c|b">ces-Moll</key>
    <key code="c">c-Moll</key>
    <key code="c|x">cis-Moll</key>
    <key code="d|b">des-Moll</key>
    <key code="d">d-Moll</key>
    <key code="d|x">dis-Moll</key>
    <key code="e|b">es-Moll</key>
    <key code="e">e-Moll</key>
    <key code="e|x">eis-Moll</key>
    <key code="f|b">fes-Moll</key>
    <key code="f">f-Moll</key>
    <key code="f|x">fis-Moll</key>
    <key code="g|b">ges-Moll</key>
    <key code="g">g-Moll</key>
    <key code="g|x">gis-Moll</key>
    <key code="a|b">as-Moll</key>
    <key code="a">a-Moll</key>
    <key code="a|x">ais-Moll</key>
    <key code="b">h-Moll</key>
    <key code="b|b">b-Moll</key>
  </xsl:param>
  <xsl:variable name="keyList" select=
   "document('')/*/xsl:param[@name='vkeys-de']/*"/>

<xsl:param name="vgenres-de">
  <key code="Sonatas">Sonaten</key>
  <key code="Preludes">Präludien</key>
  <key code="Fugues">Fugen</key>
  <key code="Concertos">Konzerte</key>
  <key code="Contredanses">Kontertänze</key>
  <key code="Masses">Messen</key>
  <key code="Symhonies">Sinfonien</key>
  <key code="Suites">Suiten</key>
  <key code="Solfeggios">Solfeggien</key>
  <key code="Minuets">Menuette</key>
</xsl:param>
<xsl:variable name="genreList" select=
 "document('')/*/xsl:param[@name='vgenres-de']/*"/>



  <xsl:template name="replace-all">
    <xsl:param name="text"/>
    <xsl:param name="array"/>
      <xsl:for-each select="$array">
          <xsl:if test="contains($text,@code)">
            <xsl:value-of select="substring-before($text,@code)"/>
            <xsl:value-of select="."/>
            <xsl:call-template name="replace-all">
              <xsl:with-param name="text" select="substring-after($text,@code)"/>
              <xsl:with-param name="array" select="$array"/>
            </xsl:call-template>
          </xsl:if>
    </xsl:for-each>
  </xsl:template>







</xsl:stylesheet>
