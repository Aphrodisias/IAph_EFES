<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- This XSLT transforms a set of EpiDoc documents into a Solr
       index document representing an index of mentioned places in those
       documents. -->

  <xsl:import href="epidoc-index-utils.xsl" />

  <xsl:param name="index_type" />
  <xsl:param name="subdirectory" />

  <xsl:template match="/">
    <add>
      <xsl:for-each-group select="//tei:placeName[@ref or @key][ancestor::tei:div/@type='edition']" group-by="concat(@ref,'-',@key,'-',@type)">
        <xsl:variable name="place">
          <xsl:choose>
            <xsl:when test="@ref">
              <xsl:choose>
                <xsl:when test="contains(@ref, '#')">
                  <xsl:value-of select="substring-after(normalize-unicode(@ref), '#')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="normalize-unicode(@ref)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="@key and not(@ref)">
              <xsl:choose>
                <xsl:when test="contains(@key, '#')">
                  <xsl:value-of select="substring-after(normalize-unicode(@key), '#')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="normalize-unicode(@key)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="placesAL" select="'../../content/xml/authority/mentionedplace.xml'"/>
        <xsl:variable name="placeID" select="document($placesAL)//tei:listPlace/tei:place[@xml:id=$place]"/>
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
              <xsl:when test="doc-available($placesAL) = fn:true() and $placeID">
                <xsl:value-of select="$placeID/tei:placeName[@xml:lang='en']" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$place"/>
              </xsl:otherwise>
            </xsl:choose>
          </field>
          <field name="index_item_type">
            <xsl:choose>
              <xsl:when test="@type='ethnic'"><xsl:text>Ethnic</xsl:text></xsl:when>
              <xsl:otherwise><xsl:text>Toponym</xsl:text></xsl:otherwise>
            </xsl:choose>
          </field>
          <field name="index_external_resource">
            <xsl:if test="doc-available($placesAL) = fn:true() and $placeID">
              <xsl:for-each select="$placeID/tei:idno">
                <xsl:value-of select="."/>
                <xsl:if test="position()!=last()"><xsl:text> </xsl:text></xsl:if>
              </xsl:for-each>
            </xsl:if>
          </field>
          <xsl:apply-templates select="current-group()" />
        </doc>
      </xsl:for-each-group>
    </add>
  </xsl:template>

  <xsl:template match="tei:placeName">
    <xsl:call-template name="field_index_instance_location" />
  </xsl:template>

</xsl:stylesheet>
