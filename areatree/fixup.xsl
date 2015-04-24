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
      
      Required parameter is mpManifests.dir.uri, which is the path to the manifests directory
      Optional parameter is debug
      Optional parameter is doDropFolios, which can be "1", "true", "yes", or "on" and when set means that any
        page that only has text content inside a float will get a drop folio (right now the heading is only
        switched to being a footer; all content remains the same, which is generally not what book publishers want)
      -->
  
  <xsl:include href="mp-dropFolioHandling.xsl"/>
  <xsl:include href="mp-atFunctions.xsl"/>
  <xsl:include href="mp-fixup.xsl"/>
  
  <xsl:param name="debug" select="'false'" as="xs:string" />
  
  <xsl:variable name="debugBoolean" 
    select="matches($debug,'true|1|on|yes', 'i')" as="xs:boolean"
  />

  <xsl:param name="mpManifests.dir.uri" required="yes" as="xs:string" />
  
  <xsl:param name="mpDoDropFolios" as="xs:string" select="'false'" />
  <xsl:variable name="d4p:doDropFoliosBoolean" as="xs:boolean" select="
    matches($mpDoDropFolios,'1|yes|true|on','i')" />
  
    <xsl:variable name="manifestFloats" as="element()">
      <pdf2Multipass:manifestFloats>
        <xsl:for-each select="collection(concat('file:/',replace($mpManifests.dir.uri,'\\','/'),'/floats/?select=*.AT.xml'))">
            <xsl:variable name="documentUri" select="xs:string(document-uri(.))" as="xs:string" />
          <pdf2Multipass:fileName><xsl:value-of select="$documentUri"/></pdf2Multipass:fileName>
        </xsl:for-each>
        </pdf2Multipass:manifestFloats>
    </xsl:variable>
  
    <xsl:template match="/">
      
      <xsl:apply-templates select="." mode="report-parameters">
        <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$debugBoolean"/>
      </xsl:apply-templates>
      
        <xsl:variable name="root" as="element()">
          <xsl:apply-templates>
            <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$debugBoolean"/>
          </xsl:apply-templates>
        </xsl:variable>
      
      <xsl:apply-templates select="$root" mode="fixup">
        <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$debugBoolean"/>
      </xsl:apply-templates>
      
    </xsl:template>
  
  <xsl:template match="ahAT:RegionViewportArea[@region-name='xsl-region-body'][descendant::*[pdf2Multipass:isPlaceholderBlock(.) and pdf2Multipass:isLandscapeFloat(.)]]" priority="30">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    
    <xsl:variable name="elemWithRole" select="descendant::*[pdf2Multipass:isPlaceholderBlock(.) and pdf2Multipass:isLandscapeFloat(.)]" as="element()" />
    <xsl:variable name="curFloatIdRoleValue" select="tokenize($elemWithRole/@role,' ')[starts-with(.,'d4pFloatId_')]" as="xs:string" />
    <xsl:variable name="curFloatId" select="substring-before(substring-after($curFloatIdRoleValue,'d4pFloatId_'),'_Page')" as="xs:string" />
    <xsl:variable name="currentPage" select="xs:integer(substring-after($curFloatIdRoleValue,'_Page'))" as="xs:integer" />
    
    <xsl:if test="$doDebug">
      <xsl:message>+ [DEBUG] Adjusting landscape float with floatId [<xsl:value-of select="$curFloatId"/>]</xsl:message>
    </xsl:if>
    
    <xsl:variable name="floatFilenameForBlockLookup" select="$manifestFloats//pdf2Multipass:fileName[contains(.,concat($curFloatId,''))]/text()" as="xs:string"/>
    
    <xsl:variable name="floatInATFile" select="document($floatFilenameForBlockLookup)//ahAT:RegionViewportArea
      [descendant::*[contains(@role,$curFloatId)]]
      [ancestor::ahAT:PageViewportArea
      [count(preceding::ahAT:PageViewportArea) = ($currentPage - 1)]]" as="element()" /> 
    
    <xsl:sequence select="$floatInATFile" />
  </xsl:template>
 
  
  <xsl:template match="ahAT:BlockArea[parent::*/parent::*[pdf2Multipass:isPlaceholderBlock(.) and not(pdf2Multipass:isLandscapeFloat(.))]]" priority="30">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:variable name="elemWithRole" select="parent::*/parent::*[pdf2Multipass:isPlaceholderBlock(.)]" as="element()" />
    <xsl:variable name="curFloatIdRoleValue" select="tokenize($elemWithRole/@role,' ')[starts-with(.,'d4pFloatId_')]" as="xs:string" />
    <xsl:variable name="curFloatId" select="substring-before(substring-after($curFloatIdRoleValue,'d4pFloatId_'),'_Page')" as="xs:string" />
    <xsl:variable name="currentPage" select="xs:integer(substring-after($curFloatIdRoleValue,'_Page'))" as="xs:integer" />
    
    <xsl:if test="$doDebug">
      <xsl:message>+ [DEBUG] Adjusting non-landscape float with floatId [<xsl:value-of select="$curFloatId"/>]</xsl:message>
    </xsl:if>
    
    <xsl:variable name="floatFilenameForBlockLookup" select="$manifestFloats//pdf2Multipass:fileName[contains(.,concat($curFloatId,''))]/text()" as="xs:string"/>
    
    <xsl:variable name="floatInATFile" select="document($floatFilenameForBlockLookup)//ahAT:BlockArea
      [contains(@role,$curFloatId)]
      [ancestor::ahAT:PageViewportArea
      [count(preceding::ahAT:PageViewportArea) = ($currentPage - 1)]]" as="element()" /> 
    
    <xsl:sequence select="$floatInATFile" />
  </xsl:template>
  
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>
    
    
  <xsl:template name="report-parameters" match="*" mode="report-parameters">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    
    <xsl:message>
      ==========================================
      
      Parameters:
      + mpManifests.dir.uri           = "<xsl:sequence select="$mpManifests.dir.uri"/>"
      + debug           = "<xsl:sequence select="$debug"/>"
      + mpDoDropFolios           = "<xsl:sequence select="$mpDoDropFolios"/>"
      
      Global variables:
      + debugBoolean           = "<xsl:sequence select="$debugBoolean"/>"
      + d4p:doDropFoliosBoolean           = "<xsl:sequence select="$d4p:doDropFoliosBoolean"/>"
      
      ==========================================
    </xsl:message>
    <xsl:apply-templates select="." mode="extension-report-parameters"/>
  </xsl:template>
  
</xsl:stylesheet>