<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <!-- This XSLT transforms a set of EpiDoc documents into a Solr
       index document representing an index of erasures in those
       documents. -->

  <xsl:import href="epidoc-index-utils.xsl" />

  <xsl:param name="index_type" />
  <xsl:param name="subdirectory" />
  <xsl:param name="w3cdur"/>
  <xsl:param name="request"/>

  <xsl:template match="/">
    <add>
      <xsl:for-each-group select="//tei:del[@rend='erasure'][translate(normalize-space(string-join(descendant::text(), '')), ' ', '')!=''][ancestor::tei:div/@type='edition']" group-by="normalize-unicode(normalize-space(string-join(descendant::text(), '')))">
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type" />
            <xsl:text>_index</xsl:text>
          </field>
          <xsl:call-template name="field_file_path" />
          <field name="index_item_name">
            <xsl:value-of select="normalize-unicode(normalize-space(string-join(descendant::text(), '')))"/>
          </field>
          <xsl:apply-templates select="current-group()">
          </xsl:apply-templates>
        </doc>
      </xsl:for-each-group>
    </add>
  </xsl:template>

  <xsl:template match="tei:del[@rend='erasure']">
    <xsl:call-template name="field_index_instance_location" />
  </xsl:template>

</xsl:stylesheet>
