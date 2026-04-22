<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- This XSLT transforms a set of EpiDoc documents into a Solr
       index document representing an index of military units in those
       documents. -->

  <xsl:import href="epidoc-index-utils.xsl" />

  <xsl:param name="index_type" />
  <xsl:param name="subdirectory" />

  <xsl:template match="/">
    <add>
      <xsl:for-each-group select="//tei:rs[@type='military'][@ref]|//tei:orgName[@type='military'][@ref]|//tei:orgName[@type='civil'][@ref]|//tei:rs[@type='military'][not(@ref)][@key]|//tei:orgName[@type='military'][not(@ref)][@key]" group-by="concat(translate(@ref, '#', ''), '-', translate(@key, '#', ''), '-', string-join(descendant::tei:addName/@nymRef, ' '))">
        <xsl:variable name="self" select="."/>
        <xsl:variable name="id">
          <xsl:choose>
            <xsl:when test="@ref">
              <xsl:value-of select="translate(@ref, '#', '')"/>
            </xsl:when>
            <xsl:when test="@key and not(@ref)">
              <xsl:value-of select="translate(@key, '#', '')"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="idno" select="document('../../content/xml/authority/organisations.xml')//tei:item[@xml:id=$id]"/>
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type" />
            <xsl:text>_index</xsl:text>
          </field>
          <xsl:call-template name="field_file_path" />
          <field name="index_item_name">
            <xsl:choose>
              <xsl:when test="$idno">
                <xsl:value-of select="$idno/tei:term[1]" />
                <xsl:if test="$idno/tei:term[2]">
              <xsl:text> / </xsl:text>
              <xsl:value-of select="$idno/tei:term[2]" />
            </xsl:if>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$id" />
              </xsl:otherwise>
            </xsl:choose>
          </field>
          <field name="index_epithet">
            <xsl:for-each select="descendant::tei:addName[@nymRef][not(ancestor::tei:rs[ancestor::tei:rs=$self])]">
              <xsl:value-of select="@nymRef" />
              <xsl:if test="position()!=last()">, </xsl:if>
            </xsl:for-each>
          </field>
          <field name="index_external_resource">
            <xsl:value-of select="$idno/tei:idno" />
          </field>
          <xsl:apply-templates select="current-group()" />
        </doc>
      </xsl:for-each-group>
    </add>
  </xsl:template>

  <xsl:template match="tei:rs[@type='military']|tei:orgName[@type='military']|tei:orgName[@type='civil']">
    <xsl:call-template name="field_index_instance_location" />
  </xsl:template>

</xsl:stylesheet>
