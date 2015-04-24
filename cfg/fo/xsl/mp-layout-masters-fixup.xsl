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
  
  <!-- This mode sets the column-count for landscape material to 1 -->
  <xsl:template match="@column-count" mode="pdf2Multipass:layout-masters-fixup" priority="30">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:if test="$doDebug">
      <xsl:message>+ [DEBUG] Landscape table, so setting @column-count for FO page reference to 1</xsl:message>
    </xsl:if>
    
    <xsl:attribute name="column-count">1</xsl:attribute>
  </xsl:template>
  
  <xsl:template match="@column-gap" mode="pdf2Multipass:layout-masters-fixup" priority="30">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:if test="$doDebug">
      <xsl:message>+ [DEBUG] Landscape table, so dropping @column-gap</xsl:message>
    </xsl:if>
    
  </xsl:template>
  
  <xsl:template match="@*|node()" mode="pdf2Multipass:layout-masters-fixup">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>