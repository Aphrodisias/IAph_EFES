<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fn="http://www.w3.org/2005/xpath-functions">

  <!-- This XSLT transforms a set of EpiDoc documents into a Solr
       index document representing an index of persons in those
       documents. -->

  <xsl:import href="epidoc-index-utils.xsl" />

  <xsl:param name="index_type" />
  <xsl:param name="subdirectory" />

  <xsl:template match="/">
    <add>
      <xsl:for-each-group select="//tei:persName[@type!='divine'][ancestor::tei:div/@type='edition']" group-by="concat(string-join(descendant::tei:name/@nymRef, ''), '-', @key)"> <!-- TO BE ADJUSTED -->
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type" />
            <xsl:text>_index</xsl:text>
          </field>
          <xsl:call-template name="field_file_path" />
          <field name="index_item_name"> <!-- TO BE ADJUSTED -->
            <xsl:choose>
              <xsl:when test="descendant::tei:name[@nymRef]">
                <xsl:for-each select="descendant::tei:name[@nymRef]">
                  <xsl:value-of select="translate(translate(normalize-space(normalize-unicode(@nymRef)), '_', '-'), '#', '')" />
                  <xsl:if test="position()!=last()"><xsl:text> </xsl:text></xsl:if>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@key"/>
              </xsl:otherwise>
            </xsl:choose>
          </field>
          <field name="index_external_resource">
              <xsl:value-of select="@ref"/> <!-- in some cases also in @key: CHECK -->
          </field>
          <xsl:apply-templates select="current-group()" />
        </doc>
      </xsl:for-each-group>
    </add>
  </xsl:template>

  <xsl:template match="tei:persName">
    <xsl:call-template name="field_index_instance_location" />
  </xsl:template>

</xsl:stylesheet>
