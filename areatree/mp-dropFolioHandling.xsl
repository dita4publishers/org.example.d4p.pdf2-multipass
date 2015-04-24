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
  
  <xsl:template match="ahAT:RegionViewportArea[@region-name='odd-body-header'][pdf2Multipass:needsDropFolio(.)]" priority="30">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    
    <xsl:if test="$doDebug">
      <xsl:message>+ [DEBUG] Adjusting odd-body-header for dropFolio handling</xsl:message>
    </xsl:if>
    
    <ahAT:RegionViewportArea is-first="{@is-first}"
      is-last="{@is-last}"
      bottom-position="{@bottom-position}"
      width="{@width}"
      height="{@height}"
      region-name="{@region-name}">
      <ahAT:RegionReferenceArea is-first="{ahAT:RegionReferenceArea/@is-first}"
        is-last="{ahAT:RegionReferenceArea/@is-last}"
        width="{ahAT:RegionReferenceArea/@width}"
        height="{ahAT:RegionReferenceArea/@height}"
        display-role="{ahAT:RegionReferenceArea/@display-role}"/>
    </ahAT:RegionViewportArea>
  </xsl:template>
  
  <xsl:template match="ahAT:RegionViewportArea[@region-name='odd-body-footer'][pdf2Multipass:needsDropFolio(.)]" priority="30">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    
    <xsl:if test="$doDebug">
      <xsl:message>+ [DEBUG] Adjusting odd-body-footer for dropFolio handling</xsl:message>
    </xsl:if>
    
    <ahAT:RegionViewportArea is-first="{@is-first}"
      is-last="{@is-last}"
      top-position="{@top-position}"
      width="{@width}"
      height="{@height}"
      region-name="{@region-name}">
      <ahAT:RegionReferenceArea is-first="{ahAT:RegionReferenceArea/@is-first}"
        is-last="{ahAT:RegionReferenceArea/@is-last}"
        width="{ahAT:RegionReferenceArea/@width}"
        height="{ahAT:RegionReferenceArea/@height}"
        display-role="{ahAT:RegionReferenceArea/@display-role}">
        <xsl:apply-templates select="../ahAT:RegionViewportArea[@region-name='odd-body-header']/ahAT:RegionReferenceArea/*" />  
      </ahAT:RegionReferenceArea>
    </ahAT:RegionViewportArea>
  </xsl:template>
  
  <xsl:template match="ahAT:RegionViewportArea[@region-name='even-body-header'][pdf2Multipass:needsDropFolio(.)]" priority="30">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    
    <xsl:if test="$doDebug">
      <xsl:message>+ [DEBUG] Adjusting even-body-header for dropFolio handling</xsl:message>
    </xsl:if>
    
    <ahAT:RegionViewportArea is-first="{@is-first}"
      is-last="{@is-last}"
      bottom-position="{@bottom-position}"
      width="{@width}"
      height="{@height}"
      region-name="{@region-name}">
      <ahAT:RegionReferenceArea is-first="{ahAT:RegionReferenceArea/@is-first}"
        is-last="{ahAT:RegionReferenceArea/@is-last}"
        width="{ahAT:RegionReferenceArea/@width}"
        height="{ahAT:RegionReferenceArea/@height}"
        display-role="{ahAT:RegionReferenceArea/@display-role}"/>
    </ahAT:RegionViewportArea>
  </xsl:template>
  
  <xsl:template match="ahAT:RegionViewportArea[@region-name='even-body-footer'][pdf2Multipass:needsDropFolio(.)]" priority="30">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    
    <xsl:if test="$doDebug">
      <xsl:message>+ [DEBUG] Adjusting even-body-footer for dropFolio handling</xsl:message>
    </xsl:if>
    
    <ahAT:RegionViewportArea is-first="{@is-first}"
      is-last="{@is-last}"
      top-position="{@top-position}"
      width="{@width}"
      height="{@height}"
      region-name="{@region-name}">
      <ahAT:RegionReferenceArea is-first="{ahAT:RegionReferenceArea/@is-first}"
        is-last="{ahAT:RegionReferenceArea/@is-last}"
        width="{ahAT:RegionReferenceArea/@width}"
        height="{ahAT:RegionReferenceArea/@height}"
        display-role="{ahAT:RegionReferenceArea/@display-role}">
        <xsl:apply-templates select="../ahAT:RegionViewportArea[@region-name='even-body-header']/ahAT:RegionReferenceArea/*" />  
      </ahAT:RegionReferenceArea>
    </ahAT:RegionViewportArea>
  </xsl:template>
  
  <xsl:function name="pdf2Multipass:needsDropFolio" as="xs:boolean">
    <xsl:param name="curNode" as="element()" />
    
    <xsl:choose>
      <xsl:when test="$d4p:doDropFoliosBoolean">
        <xsl:variable name="numberOfBlocksOutsideTheFloatInXslRegionBody"
          select="count($curNode/ancestor-or-self::ahAT:PageViewportArea
          //ahAT:RegionViewportArea[@region-name='xsl-region-body']
          //ahAT:BlockArea[ancestor-or-self::ahAT:BlockArea[not(@role) or not(contains(@role,'d4pFloatId_'))]])
          " as="xs:integer" />
        <!-- Need to dig into and see why the count is 1 when there is only a float on the page and not 0 -->
        
        <xsl:choose>
          <xsl:when test="$numberOfBlocksOutsideTheFloatInXslRegionBody > 1">
            <xsl:sequence select="false()"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:sequence select="true()"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
   
  </xsl:function>
  
</xsl:stylesheet>