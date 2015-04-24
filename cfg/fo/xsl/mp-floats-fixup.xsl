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
  
  <xsl:template match="*[pdf2Multipass:needsMultiPassHandling(.)]" mode="pdf2Multipass:floats-fixup" priority="30">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    
    <xsl:variable name="curFloatId" select="pdf2Multipass:getFloatId(.)"
      as="xs:string"/>
    
    <xsl:if test="$doDebug">
      <xsl:message>+ [DEBUG] Handling floated element with d4pFloatId: [<xsl:value-of select="$curFloatId"/>]</xsl:message>
    </xsl:if>
    
    <xsl:variable name="curFloatElement" as="element()" select="." />
    
    <xsl:variable name="curFloatFoFile"
      select="concat($work.dir.url,'mpManifests/floats/',$curFloatId,'.fo')" as="xs:string"/>
    <xsl:variable name="curFloatATFile" as="xs:string"
      select="replace(replace($curFloatFoFile,'.fo','.AT.xml'),'file:/','')"/>
    
    <xsl:choose>
      <xsl:when test="not(java:exists(java:new(replace($curFloatFoFile,'file:/',''))))">
        <!-- floats that don't go through the multi pass won't have an fo file so we just output them
          [assume they belong where they are in the DITA file] -->
        <xsl:sequence select="."/>
      </xsl:when>
      <xsl:otherwise>
        <!-- if we have a Fo file, then we do our magic -->
        
        <xsl:variable name="curFloatAT"
          select="document(concat('file:/',replace($curFloatATFile,'\\','/')))"
          as="document-node()"/>
        
        <!-- Note: We need to get the page-width accounting for margins; right now this code assumes the
          page-width and the margins are in millimeters. -->
        <!-- TODO: Generalize measurement handling -->
        <xsl:variable name="page-width-with-margins" as="xs:double"
          select="xs:double(substring-before($page-width,'mm')) - xs:double(substring-before($page-margin-inside,'mm'))
          - xs:double(substring-before($page-margin-outside,'mm'))" />
        <xsl:variable name="pageHeight" select="'100%'" as="xs:string"/>
        <xsl:variable name="pageWidth" select="concat(xs:string($page-width-with-margins),'mm')" as="xs:string"/>
        
        <xsl:variable name="numPagesNeededForFloat"
          select="count($curFloatAT//ahAT:PageViewportArea)" as="xs:integer"/>
        
        <xsl:choose>
          <xsl:when test="pdf2Multipass:isFoLandscapeFloat(.)">
            <!-- landscape floats always go through the multi pass process -->
            
            <xsl:for-each select="1 to $numPagesNeededForFloat">
              <fo:float axf:float="page top">
                <fo:block-container
                  role="{concat($curFloatId,'_Page',.,' placeholder landscape ')}"
                  width="{$pageWidth}" height="{$pageHeight}" span="all" >
                  
                  <fo:block span="all"> placeholder for landscape floatId [<xsl:value-of select="$curFloatId"/>];
                    page <xsl:value-of select="."/> of <xsl:value-of select="$numPagesNeededForFloat"/> needed                  
                  </fo:block>
                  
                </fo:block-container>
              </fo:float>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <!-- non landscape float so... if one page or less don't worry about it -->
            <xsl:choose>
              <xsl:when test="$numPagesNeededForFloat = 1">
                
                <xsl:sequence select="."/> <!-- the context item is a fo:float -->
                
              </xsl:when>
              <xsl:otherwise>
                <!-- nonlandscape float longer than a page, so we need to find out how many pages
                and then for last page see how far down it goes -->
                <xsl:for-each select="1 to $numPagesNeededForFloat">
                  <xsl:choose>
                    <xsl:when test=". ne $numPagesNeededForFloat">
                      <fo:float axf:float="{ if (pdf2Multipass:isFo1ColFloat($curFloatElement)) then 'col top' else 'page top'}">
                        <fo:block-container role="{concat($curFloatId,'_Page',.,' placeholder ')}"
                          width="100%" height="100%">
                          
                          <fo:block span="all"> placeholder for floatId [<xsl:value-of select="$curFloatId"/>];
                            page <xsl:value-of select="."/> of <xsl:value-of select="$numPagesNeededForFloat"/> needed                  
                          </fo:block>
                          
                        </fo:block-container>
                      </fo:float>
                    </xsl:when>
                    <xsl:otherwise>
                      <!-- last page so we need a block for the size of the float -->
                      <xsl:variable name="lastPageOfFloat"
                        select="$curFloatAT//ahAT:PageViewportArea
                        [last()]"
                        as="element()"/>
                      <!-- the first BlockArea of the last page should contain the float...
                       -->
                      <xsl:variable name="sizeOfFloat"
                        select="$lastPageOfFloat//ahAT:BlockArea[1]/@height"
                        as="xs:string+"/>
                      <fo:float axf:float="{ if (pdf2Multipass:isFo1ColFloat($curFloatElement)) then 'col top' else 'page top'}">
                        <fo:block-container role="{concat($curFloatId,'_Page',.,' placeholder ')}"
                          width="100%" height="{$sizeOfFloat[1]}" margin-bottom=".5in">
                          
                          <fo:block span="all"> placeholder for last page floatId [<xsl:value-of select="$curFloatId"/>];
                            page <xsl:value-of select="."/> of <xsl:value-of select="$numPagesNeededForFloat"/> needed                  
                          </fo:block>
                          
                        </fo:block-container>
                      </fo:float>
                      
                    </xsl:otherwise>
                  </xsl:choose>
                  
                </xsl:for-each>
                
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
        
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
  <xsl:template match="@*|node()" mode="pdf2Multipass:floats-fixup">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>