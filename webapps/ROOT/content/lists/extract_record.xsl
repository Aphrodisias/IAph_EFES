<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:t="http://www.tei-c.org/ns/1.0">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <!-- ============== run against all_inscriptions.xml ============== -->
    
    <xsl:template match="/">
        <body>
            <!--<xsl:variable name="images">-->
                <xsl:for-each select="//t:list/t:item">
                    <xsl:variable name="filename" select="concat('../xml/epidoc/', @n)"/>
                    <xsl:for-each select="document($filename)//t:div[@type='history'][@n='record']//t:p">
                        <div n="{substring-after(substring-before($filename, '.xml'), '../xml/epidoc/')}"><xsl:copy-of select="."/></div>
                    </xsl:for-each>
                </xsl:for-each>
            <!--</xsl:variable>-->
        </body>
    </xsl:template>

</xsl:stylesheet>
