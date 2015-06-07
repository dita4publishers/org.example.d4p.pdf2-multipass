<?xml version='1.0' encoding='ASCII'?>
<xsl:stylesheet version="2.0"
  xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
  xmlns:e="org.example.d4p.pdf2-multipasspdf2-multipass"
  xmlns:fo="http://www.w3.org/1999/XSL/Format" 
  xmlns:opentopic="http://www.idiominc.com/opentopic"
  xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:pdf2MultipassHelperRenderAreaTree="java:org.example.d4p.pdf2Multipass.helper.RenderAreaTree"
  xmlns:pdf2Multipass="http://www.dita4publishers.org/example/pdf2-multipass"
  xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
  xmlns:java="java:java.io.File"
  xmlns:ahAT="http://www.antennahouse.com/names/XSL/AreaTree"
  exclude-result-prefixes="ditaarch opentopic e opentopic-func xs xsl pdf2MultipassHelperRenderAreaTree axf pdf2Multipass ahAT">
  
  <xsl:include href="mp-fo-functions.xsl" />
  <xsl:include href="mp-root-template-override.xsl"/>
  <xsl:include href="mp-layout-masters-fixup.xsl"/>
  <xsl:include href="mp-floats-fixup.xsl"/>
  
  <xsl:param name="debug" select="'false'" as="xs:string" />
  
  <xsl:variable name="debugBoolean" 
    select="matches($debug,'true|1|on|yes', 'i')" as="xs:boolean"
  />
  
  <!-- template override for similar template in org.dita.pdf2:xsl:fo/tables.xsl;
  override accomplishes two things:
  -Adds doDebug param (and debug message
  -Wraps the table in a fo:float element -->
  <xsl:template match="*[contains(@class, ' topic/table ')]">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    
    <xsl:variable name="scale">
      <xsl:call-template name="getTableScale"/>
    </xsl:variable>
    <xsl:variable name="curFloatId" select="concat('d4pFloatId_',generate-id())" as="xs:string"/>
    
    <xsl:if test="$doDebug">
      <xsl:message>+ [DEBUG] the d4pFloatId is [<xsl:value-of select="$curFloatId"/>]</xsl:message>
    </xsl:if>
    
    <fo:float>
      <xsl:choose>
        <xsl:when test="@outputclass=('floatBottom')">
          <xsl:attribute name="axf:float">page bottom</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="axf:float">page top</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      
      <xsl:attribute name="role"
        select="
        if (@outputclass='landscape') then
        concat(' d4pFloat ', $curFloatId, ' landscape ')
        else
        if (@outputclass='1col') then
        concat(' d4pFloat ', $curFloatId, ' 1col ')
        else
        concat(' d4pFloat ', $curFloatId, ' ')"/>
      
      <fo:block xsl:use-attribute-sets="table">
        <xsl:call-template name="commonattributes"/>
        <xsl:if test="not(@id)">
          <xsl:attribute name="id">
            <xsl:call-template name="get-id"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="not($scale = '')">
          <xsl:attribute name="font-size"><xsl:value-of select="concat($scale, '%')"/></xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
      </fo:block>
    </fo:float>
  </xsl:template>
  
</xsl:stylesheet>
