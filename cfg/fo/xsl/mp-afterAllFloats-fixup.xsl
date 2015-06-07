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
  
  
  <!-- This is inefficient, we should be using a key -->
  <xsl:template match="fo:float[contains(@axf:float,'bottom')]" mode="pdf2Multipass:afterAllFloats-fixup" priority="20">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:param name="areaTreeForFo" as="document-node()?" tunnel="yes" />
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="#current"/>
      <xsl:variable name="d4pFloatId" select="pdf2Multipass:getFloatId(.)" as="xs:string?"/>
      <xsl:choose>
        <xsl:when test="$areaTreeForFo//ahAT:PageViewportArea[.//*[@role='afterAllFloats'] 
          and .//*[contains(@role,$d4pFloatId)]]">
          <!-- if there is a page in the areatree that contains material from the cur float and the 
          block that should only appear after floats -->
          <xsl:attribute name="axf:float"><xsl:value-of select="replace(@axf:float,'bottom','top')"/></xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  
  <xsl:template match="@*|node()" mode="pdf2Multipass:afterAllFloats-fixup">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  
</xsl:stylesheet>