# org.example.d4p.pdf2-multipass
Example of a multipass PDF generation process that extends the base PDF2 plugin. Currently handles floated content that is longer than a page, content that is to be rotated (i.e., landscape orientation on a portrait-oriented page), and the setting of drop folios. Presently only works with AntennaHouse 6.x.

## Primary goals
* Don’t lose floated content that is longer than a page
* Allow for content to be easily rotated into a landscape orientation while page rotation remains in portrait orientation (and allow said content to be floated)
* Allow for drop folios to be activated on pages that do not have main text (i.e., a page that consists of only table or fig content)

## Requirements
* AntennaHouse XSL Formatter 6.x
* DITA-OT 1.8.x (not yet tested on 2.x; the only requirement on DITA-OT version are names of templates used in overridden templates)

## Installation
* Clone or otherwise download the plugin to your DITA-OT plugins directory
* Find “XfoJavaCtl.jar” (the Antenna House Java API jar) and put a copy of it in the org.example.d4p.pdf2-multipass/lib
* Run integrator.xml

## Using the test content
* The test content is a DITA Map (with a key-defining map and a topicref to a DITA topic)
* The test contents most of the major different kinds of tables:
    * Less than a page long
    * Longer than a page
    * Landscape orientation
* The transtype for the plugin is ex-pdf2-mp

## Building the MultiPass Helper library
* NOTE: The MultiPass Helper library only has one class (org.example.d4p.pdf2Multipass.helper.RenderAreaTree), which given a FO file will render the AreaTree and save it as the given file name. There is an ant build file for building the helper library if you feel so inclined.
* Use the eclipse project and ant build target in src/java
* Note: You must have the Antenna House Java API in your build path (this git repo does not include the java API library)
* If you set the ant property “pdf2MultipassHelperDeployDir” and use the ant target “dist-deploy-helper”, then the library will also be deployed for you

## Other notes
* Landscape orientation is handled by adding “landscape” to the fo:float’s @role, so some stylesheet writing is required at this time
* This should work for any content in a <fo:float> that floats to the top or bottom of a page (column floats should work if content does not exceed a page; side floats have not been attempted or tested)
* Dropfolio handling only works for defined regions of odd-body-header, odd-body-footer, even-body-header, even-body-footer
* Float fixup only works for items in @region-name xsl-body-region
* Page width/height requirements must currently be specified as mm (there is some logic that needs to be altered so that different units can be used)
* Landscape tables are centered on the resulting page
