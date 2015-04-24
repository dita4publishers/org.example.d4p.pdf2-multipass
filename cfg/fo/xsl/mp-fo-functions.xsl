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
  
  <!-- this function checks whether a given element needs POTENTIAL multipass handling; 
      it does not know how long something is (I mention that because if content was one
    page or less, then it will float fine [in AXF]). Right now this function simply checks to see if
    the element is an fo:float and if it is, then it returns true. This lets stylesheet writers
    easily override the function and stipulate their own conditions.
  -->
  <xsl:function name="pdf2Multipass:needsMultiPassHandling" as="xs:boolean">
    <xsl:param name="curElem" as="element()"/>
    
    <xsl:choose>
      <xsl:when test="name($curElem) = 'fo:float'">
        <xsl:sequence select="true()" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <!-- this function checks whether a given element is a landscape element -->
  <!-- FIXME: Need better logic for determining; right now requires stylesheet writer to provide the word
  'landscape' as part of the element's @role -->
  <xsl:function name="pdf2Multipass:isFoLandscapeFloat" as="xs:boolean">
    <xsl:param name="curElem" as="element()"/>
    <xsl:choose>
      <xsl:when test="contains($curElem/@role, ' landscape ')">
        <xsl:sequence select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <!-- this function checks whether a given element is a 1 column element -->
  <!-- FIXME: Need better logic for determining; right now requires stylesheet writer to provide the word
  '1col' as part of the element's @role -->
  <xsl:function name="pdf2Multipass:isFo1ColFloat" as="xs:boolean">
    <xsl:param name="curElem" as="element()"/>
    <xsl:choose>
      <xsl:when test="contains($curElem/@role, ' 1col ')">
        <xsl:sequence select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="pdf2Multipass:getFloatId" as="xs:string">
    <xsl:param name="curElem" as="element()" />
    <xsl:choose>
      <xsl:when test="$curElem/@role">
        <xsl:sequence select="tokenize($curElem/@role,' ')[starts-with(.,'d4pFloatId_')][1]" />
        <!-- we should only have one d4pFloatId_ in the @role but just in case, we will take the first one;
         might need to do some other error checking, such as check if there is more than one in the @role -->
      </xsl:when>
    </xsl:choose>
  </xsl:function>
  
</xsl:stylesheet>