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
  
  <xsl:template match="ahAT:PageViewportArea[count(preceding::ahAT:PageViewportArea) > 0]/@is-first" mode="fixup" priority="30">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    
    <xsl:if test="$doDebug">
      <xsl:message>+ [DEBUG] Dropping @is-first from PageViewportArea element that is no longer first due to float fixup</xsl:message>
    </xsl:if>
    
  </xsl:template>
  
  <xsl:template match="ahAT:PageViewportArea[count(following::ahAT:PageViewportArea) > 0]/@is-last" mode="fixup" priority="30">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    
    <xsl:if test="$doDebug">
      <xsl:message>+ [DEBUG] Dropping @is-last from PageViewportArea element that is no longer last due to float fixup</xsl:message>
    </xsl:if>
    
  </xsl:template>
  
  <xsl:template match="ahAT:BlockViewportArea/@right-position" mode="fixup" priority="30">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    
    <xsl:if test="$doDebug">
      <xsl:message>+ [DEBUG] Dropping @right-position from BlockViewportArea element after float fixup, this allows for centering of landscape tables</xsl:message>
    </xsl:if>
    
  </xsl:template>
  
  <xsl:template match="ahAT:BlockViewportArea" mode="fixup" priority="30">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:choose>
        <xsl:when test="@right-position">
          <xsl:choose>
            <xsl:when test="not(contains(@right-position,'pt'))">
              <xsl:message terminate="yes">right-position is not in pt size</xsl:message>
            </xsl:when>
            <xsl:otherwise>
              
              <xsl:if test="$doDebug">
                <xsl:message>+ [DEBUG] Adjusting @left-position, which allows for centering of landscape tables</xsl:message>
              </xsl:if>
              
              <xsl:attribute name="left-position"><xsl:value-of select="concat(xs:double(substring-before(@right-position,'pt')) div 2, 'pt')"/></xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>
      <xsl:apply-templates select="node()" />
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@*|node()" mode="fixup">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="#current" />
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>