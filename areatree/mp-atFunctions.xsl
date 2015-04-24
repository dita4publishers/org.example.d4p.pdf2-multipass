<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ahAT="http://www.antennahouse.com/names/XSL/AreaTree"
  xmlns:pdf2Multipass="http://www.dita4publishers.org/example/pdf2-multipass"
  xmlns:d4p="http://www.dita4publishers.org"
  exclude-result-prefixes="xs ahAT pdf2Multipass d4p"
  version="2.0">
  
  <!--
      
      This stylesheet handles replacing dummy blocks with the actual material that was floated.
      
      (c) 2015 DITA4Publishers
      -->
    
  <xsl:function name="pdf2Multipass:isLandscapeFloat" as="xs:boolean">
    <xsl:param name="context" as="element()"/>
    <xsl:choose>
      <xsl:when test="pdf2Multipass:isFloatBlock($context)">
        <xsl:sequence select="contains($context/@role,' landscape ')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="pdf2Multipass:isPlaceholderBlock" as="xs:boolean">
    
    <xsl:param name="context" as="element()"/>
    <xsl:choose>
      <xsl:when test="pdf2Multipass:isFloatBlock($context)">
        <xsl:sequence select="contains($context/@role,' placeholder ')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="pdf2Multipass:isFloatBlock" as="xs:boolean">
    
    <xsl:param name="context" as="element()" />
    <xsl:choose>
      <xsl:when test="contains($context/@role,'d4pFloatId_')">
        <xsl:sequence select="true()"/>    
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:function>
    
</xsl:stylesheet>