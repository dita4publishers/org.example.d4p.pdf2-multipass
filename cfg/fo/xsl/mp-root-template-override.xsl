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
  
  <!-- template override for similar template in org.dita.pdf2:xsl:fo/root-processing.xsl -->
  <xsl:template match="/" name="rootTemplate">
    
    <xsl:choose>
      <xsl:when test="not(function-available('pdf2MultipassHelperRenderAreaTree:ExecuteAxf'))">
        <xsl:message terminate="yes">Java dependency 
          [org.example.d4p.pdf2Multipass.helper.RenderAreaTree#ExecuteAxf] 
          not found. Check your classpath.</xsl:message>
      </xsl:when>
    </xsl:choose>
    
    <xsl:call-template name="validateTopicRefs"/>
    
    <xsl:variable name="foRootElem" as="element(fo:root)">
      
      <fo:root xsl:use-attribute-sets="__fo__root">
        <xsl:call-template name="createMetadata"/>
        <xsl:call-template name="createLayoutMasters"/>
        
        <xsl:call-template name="createBookmarks"/>
        
        <xsl:call-template name="createFrontMatter"/>
        
        <xsl:if test="not($retain-bookmap-order)">
          <xsl:call-template name="createToc"/>
        </xsl:if>
        
        <!--        <xsl:call-template name="createPreface"/>-->
        
        <xsl:apply-templates>
          <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$debugBoolean"/>
        </xsl:apply-templates>
        
        <xsl:if test="not($retain-bookmap-order)">
          <xsl:call-template name="createIndex"/>
        </xsl:if>
        
      </fo:root>
    </xsl:variable>
    
    
    <!-- $foRootElem has all of the layout master set, etc. elements that we need
      The floating element handling code should be the last mode run (currently mp-float-fixup)
      
      -->
    
    <xsl:for-each
      select="$foRootElem//fo:float[pdf2Multipass:needsMultiPassHandling(.)]">
      <xsl:variable name="curFloatId"
        select="pdf2Multipass:getFloatId(.)" as="xs:string"/>
      
      
      
      <xsl:variable name="curFloatFoFile"
        select="concat($work.dir.url,'mpManifests/floats/',$curFloatId,'.fo')" as="xs:string"/>
      
      <xsl:result-document href="{$curFloatFoFile}">
        <fo:root>
          <xsl:choose>
            <xsl:when test="pdf2Multipass:isFoLandscapeFloat(.)">
              <xsl:apply-templates select="$foRootElem//fo:layout-master-set" mode="pdf2Multipass:layout-masters-fixup">
                <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$debugBoolean"/>
              </xsl:apply-templates>
              
            </xsl:when>
            <xsl:otherwise>
              <xsl:sequence select="$foRootElem//fo:layout-master-set" />    
            </xsl:otherwise>
          </xsl:choose>
          
          <xsl:variable name="currentItemMasterReference" 
            select="ancestor::fo:page-sequence/@master-reference"
            as="xs:string" />
          
          <!-- do not select the fo:float but add its @role to our faux float block -->
          <xsl:variable name="foToWriteOut" as="element(fo:block)">
            <fo:block>
              <xsl:attribute name="role"><xsl:sequence select="@role/string()"/></xsl:attribute>
              <xsl:sequence select="./*"/> 
            </fo:block>
          </xsl:variable>
          
          <fo:page-sequence master-reference="{$currentItemMasterReference}">
            <fo:flow flow-name="xsl-region-body">
              <xsl:choose>
                <xsl:when test="pdf2Multipass:isFoLandscapeFloat(.)">
                  <fo:block-container reference-orientation="90" display-align="center">
                    <xsl:sequence select="$foToWriteOut" />
                  </fo:block-container>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:sequence select="$foToWriteOut" />
                </xsl:otherwise>
              </xsl:choose>
              
            </fo:flow>
          </fo:page-sequence>
        </fo:root>
      </xsl:result-document>
      
      
      <!-- must remove "file:/" from URIs for these two variables -->
      <xsl:variable name="inputFoFile" as="xs:string"
        select="replace($curFloatFoFile,'file:/','')"/>
      <xsl:variable name="outputAtFile" as="xs:string"
        select="replace(replace($curFloatFoFile,'.fo','.AT.xml'),'file:/','')"/>
      
      <xsl:message terminate="no">+ [INFO] Result of RenderAreaTree#ExecuteAxf: [<xsl:value-of select="pdf2MultipassHelperRenderAreaTree:ExecuteAxf($inputFoFile,$outputAtFile)"/>]</xsl:message>
      
    </xsl:for-each>
    
    <xsl:variable name="foRootElem" as="element(fo:root)">
      <xsl:apply-templates select="$foRootElem" mode="pdf2Multipass:floats-fixup">
        <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$debugBoolean"/>
      </xsl:apply-templates>
    </xsl:variable>
    
    <xsl:sequence select="$foRootElem"/>
    
  </xsl:template>
  
</xsl:stylesheet>