<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:zs="http://www.loc.gov/zing/srw/" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="marc">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

  <xsl:param name="varFile"/>

  <xsl:variable name="gVariables" select="document($varFile)"/>
  <xsl:variable name="newline">\newline </xsl:variable>
  <xsl:variable name="par">\par </xsl:variable>
  <xsl:variable name="quote">"</xsl:variable>
  <xsl:variable name="apos">'</xsl:variable>

  <xsl:template match="/">
    <document>
      <xsl:apply-templates select="//marc:record">
	      <xsl:sort select="marc:datafield[@tag=100] = false()" lang="de"/>
        <xsl:sort select="translate(translate(marc:datafield[@tag=100]/marc:subfield[@code='a'], concat('[]', $apos), ''), 'äöüšÄÖÜŠ', 'aousAOUS')" lang="de"/>
        <xsl:sort select="translate(translate(marc:datafield[@tag=240 or @tag=130]/marc:subfield[@code='a'], '[]',''), 'äöüšÄÖÜŠ', 'aousAOUS')" lang="de"/>
        <xsl:sort select="translate(marc:datafield[@tag=240 or @tag=130]/marc:subfield[@code='r'], 'CcDdEeFfGgAaBb', '0123456789ABCD')" lang="de"/>
	      <!--
        <xsl:sort select="translate(translate(marc:datafield[@tag=100]/marc:subfield[@code='a'], concat('[]', $apos), ''), 'äöüšÄÖÜŠ', 'aousAOUS')" lang="de"/>
        <xsl:sort select="translate(translate(marc:datafield[@tag=240]/marc:subfield[@code='a'], '[]',''), 'äöüšÄÖÜŠ', 'aousAOUS')" lang="de"/>
	<xsl:sort select="translate(translate(marc:datafield[@tag=130]/marc:subfield[@code='a'], '[]',''), 'äöüšÄÖÜŠ', 'aousAOUS')" lang="de"/>

	      <xsl:sort select="marc:datafield[@tag=240 or @tag=130]/marc:subfield[@code='a']" lang="de"/>

-->
     </xsl:apply-templates>
    </document>
  </xsl:template>

  <xsl:template match="marc:record">
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
      <xsl:apply-templates select="marc:datafield[@tag='730']"/>
      <xsl:apply-templates select="marc:datafield[@tag='245']"/>
      <xsl:apply-templates select="marc:datafield[@tag=300]/marc:subfield[@code=8]">
        <xsl:sort select="."/>
        <xsl:with-param name="ms" select="marc:datafield[@tag='593']"/>
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
      <xsl:apply-templates select="marc:datafield[@tag='510']"/>
      <xsl:apply-templates select="marc:controlfield[@tag='001']"/>
      <xsl:apply-templates select="marc:datafield[@tag='852']"/>
      <xsl:apply-templates select="marc:datafield[@tag='773']"/>
      <xsl:if test="marc:datafield[@tag='774']">
        <entries before="\par ">
          <xsl:apply-templates select="marc:datafield[@tag='774']"/>
        </entries>
      </xsl:if>
    </record>
  </xsl:template>

  <xsl:template match="marc:controlfield[@tag='001']">
    <rism_id before="\par RISM-ID: ">
      <xsl:value-of select="."/>
    </rism_id>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='100']">
    <xsl:param name="pos"/>
    <composer>
      <xsl:if test="marc:subfield[@code='j']='Conjectural'">
        <xsl:attribute name="before"><xsl:value-of select="concat($par, '\vspace{16pt} \textcolor{darkblue}{\textbf{?')"/></xsl:attribute>
        <xsl:attribute name="after"><xsl:value-of select="'?'"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="marc:subfield[@code='j']!='Conjectural' or not(marc:subfield[@code='j'])">
        <xsl:attribute name="before"><xsl:value-of select="concat($par, '\vspace{16pt} \textcolor{darkblue}{\textbf{')"/></xsl:attribute>
      </xsl:if>
      <xsl:value-of select="marc:subfield[@code='a']"/>
    </composer>
    <xsl:choose>
    <xsl:when test="marc:subfield[@code='d']">
      <life_date before=" (">
        <xsl:attribute name="after">)}}</xsl:attribute>
      <xsl:value-of select="marc:subfield[@code='d']"/>
    </life_date>
  </xsl:when>
  <xsl:otherwise>
    <life_date after="}}}}"/>
  </xsl:otherwise>
</xsl:choose>
    <id before="\hfillplus{{[" after="]}}"><xsl:value-of select="$pos"/></id>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='130']">
    <xsl:param name="pos"/>
    <composer>
      <xsl:attribute name="before"><xsl:value-of select="concat($par, '\vspace{16pt} \textcolor{darkblue}{\textbf{', $gVariables/*/var[@code='collection'], '}}')"/></xsl:attribute></composer>
    <id before="\hfillplus{{[" after="]}}"><xsl:value-of select="$pos"/></id>
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

  <xsl:template match="marc:datafield[@tag='730']">
    <further_title>
      <xsl:choose>
        <xsl:when test="preceding-sibling::*[1]/@tag!=@tag">
          <xsl:attribute name="before"><xsl:value-of select="concat($newline, $gVariables/*/var[@code='further_title'])"/></xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="before"><xsl:value-of select="'; '"/></xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="marc:subfield[@code='a']"/>
      <xsl:if test="marc:subfield[@code='k']">. <xsl:value-of select="marc:subfield[@code='k']"/></xsl:if>
      <xsl:if test="marc:subfield[@code='o']">. <xsl:value-of select="marc:subfield[@code='o']"/></xsl:if>
    </further_title>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='245']">
    <original_title>
      <xsl:attribute name="before"><xsl:value-of select="concat($par, '\begin{itshape}')"/></xsl:attribute>
      <xsl:attribute name="after"><xsl:value-of select="'\end{itshape} '"/></xsl:attribute>
      <xsl:call-template name="superscript">
        <xsl:with-param name="text" select="marc:subfield[@code='a']"/>
      </xsl:call-template>
    </original_title>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag=300]/marc:subfield[@code=8]">
    <xsl:param name="ms"/>
    <xsl:for-each select=".">
      <xsl:sort select="." lang="de"/>
      <xsl:variable name="layer" select="."/>
      <layer>
        <xsl:attribute name="before"><xsl:value-of select="concat($par, '\textcolor{darkblue}{\ding{\numexpr181 + ', .,'}}')"/></xsl:attribute>
        </layer>
        <xsl:for-each select="$ms">
          <xsl:if test="marc:subfield[@code=8]=$layer">
            <ms>
              <xsl:value-of select="marc:subfield[@code='a']"/>
            </ms>
          </xsl:if>
          </xsl:for-each>
      <xsl:for-each select="../../marc:datafield/marc:subfield[@code=8][.=$layer]">
        <xsl:sort select="translate(../@tag, '2357', '1234')" order="ascending"/>
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
      <xsl:when test="../@tag=563">
        <xsl:call-template name="binding" select="../marc:datafield"/>
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

  <xsl:template name="binding">
    <binding>
      <xsl:attribute name="before"><xsl:value-of select="concat($newline, $gVariables/*/var[@code='binding'])"/></xsl:attribute>
      <xsl:value-of select="../marc:subfield[@code='a']"/>
    </binding>
  </xsl:template>

  <xsl:template name="n300">
    <xsl:variable name="layer" select="../marc:subfield[@code=8]"/>
    <score before="{$newline}">
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
        <xsl:attribute name="before"><xsl:value-of select="concat($newline, $gVariables/*/var[@code='copyist'], ': ')"/></xsl:attribute>
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
        <xsl:attribute name="before"><xsl:value-of select="concat($newline, $gVariables/*/var[@code='watermark'], ': ')"/></xsl:attribute>
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
      <xsl:call-template name="superscript">
        <xsl:with-param name="text" select="../marc:subfield[@code='a']"/>
      </xsl:call-template>
    </material-note>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='031']">
    <xsl:param name="pos"/>
    <no before="\par ">
      <xsl:value-of select="marc:subfield[@code='a']"/>.<xsl:value-of select="marc:subfield[@code='b']"/>.<xsl:value-of select="marc:subfield[@code='c']"/>
    </no>
    <xsl:if test="marc:subfield[@code='m']"> 
      <inc_score><xsl:value-of select="marc:subfield[@code='m']"/></inc_score>
      </xsl:if>
    <xsl:if test="marc:subfield[@code='d']"> 
      <inc_title before=", \begin{{itshape}}" after="\end{{itshape}}">
        <xsl:call-template name="superscript">
          <xsl:with-param name="text" select="marc:subfield[@code='d']"/>
        </xsl:call-template>
      </inc_title>
    </xsl:if>
 
    <xsl:if test="marc:subfield[@code='r']"> 
      <inc_key before=", "><xsl:value-of select="marc:subfield[@code='r']"/></inc_key>
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



  <xsl:template match="marc:datafield[@tag='510']">
    <rismseries>      
      <xsl:attribute name="before"><xsl:value-of select="concat($newline, $gVariables/*/var[@code='series'])"/></xsl:attribute>
      <xsl:value-of select="marc:subfield[@code='a']"/>
    </rismseries>
    <rismnumber><xsl:value-of select="marc:subfield[@code='c']"/></rismnumber>
  </xsl:template>


  <xsl:template match="marc:datafield[@tag='500']">
    <xsl:choose>
      <xsl:when test="marc:subfield[@code=8]"/>
      <xsl:when test="not(marc:subfield[@code=8])">
        <xsl:if test="not(contains(marc:subfield[@code='a'], 'digital_objects'))">
        <note><xsl:attribute name="before"><xsl:value-of select="$par"/></xsl:attribute>
          <xsl:call-template name="superscript">
            <xsl:with-param name="text" select="marc:subfield[@code='a']"/>
           </xsl:call-template>
         </note>
       </xsl:if>
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
        <lit before="\newline {$gVariables/*/var[@code='lit']}: "><xsl:value-of select="marc:subfield[@code='a']"/></lit>
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
  
  <xsl:template match="marc:datafield[@tag='774']">
    <entry-link>
      <xsl:value-of select="marc:subfield[@code='w']"/>
    </entry-link>
  </xsl:template>


  <!-- This function is called by note fields and originaltitle --> 
  <xsl:template name="superscript">
    <xsl:param name="text"/>
    <xsl:choose>
      <xsl:when test="contains($text,'|')">
        <xsl:value-of select="substring-before($text,'|')"/>
        <xsl:variable name="resttext" select="substring-after($text, '|')"/>
        <xsl:choose>
          <xsl:when test="substring($resttext,1,1)!=' '">
            <xsl:value-of select="'\textsuperscript{'"/>
            <xsl:value-of select="substring($resttext,1,1)"/>
            <xsl:value-of select="'}'"/>
          </xsl:when>
          <xsl:when test="substring($resttext,1,1)=' '">
            <xsl:value-of select="'| '"/>
          </xsl:when>
        </xsl:choose>
       <xsl:call-template name="superscript">
          <xsl:with-param name="text" select="substring($resttext,2)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>








</xsl:stylesheet>
