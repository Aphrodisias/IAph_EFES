<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fn="http://www.w3.org/2005/xpath-functions">

  <!-- This XSLT transforms a set of EpiDoc documents into a Solr
       index document representing an index of month names in those
       documents. -->

  <xsl:import href="epidoc-index-utils.xsl" />

  <xsl:param name="index_type" />
  <xsl:param name="subdirectory" />

  <xsl:template match="/">
    <add>
      <xsl:for-each-group select="//tei:rs[@type='month'][@ref][ancestor::tei:div/@type='edition']" group-by="@ref">
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type" />
            <xsl:text>_index</xsl:text>
          </field>
          <xsl:call-template name="field_file_path" />
          <xsl:variable name="ref" select="replace(@ref, '#', '')"/>
          <xsl:variable name="monthsAL" select="'../../content/xml/authority/month.xml'"/>
          <xsl:variable name="month" select="document($monthsAL)//tei:list/tei:item[@xml:id=$ref]"/>
          <field name="index_item_name">
            <xsl:choose>
              <xsl:when test="doc-available($monthsAL) = fn:true() and $month">
                <xsl:for-each select="$month/tei:term">
                  <xsl:value-of select="."/>
                  <xsl:if test="position()!=last()"><xsl:text> | </xsl:text></xsl:if>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$ref"/>
              </xsl:otherwise>
            </xsl:choose>
          </field>
          <!--<field name="index_attested_form">
            <xsl:choose>
              <xsl:when test="descendant::tei:w[@lemma] or descendant::tei:num">
                <xsl:for-each select="descendant::tei:w[@lemma]|descendant::tei:num">
                  <xsl:choose>
                    <xsl:when test="@lemma">
                      <xsl:value-of select="translate(translate(normalize-space(normalize-unicode(@lemma)), '_', '-'), '#', '')" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="." />
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:if test="position()!=last()"><xsl:text> </xsl:text></xsl:if>
                </xsl:for-each>
              </xsl:when>
            </xsl:choose>
          </field>-->
          <field name="index_external_resource">
            <xsl:if test="doc-available($monthsAL) = fn:true() and $month">
              <xsl:for-each select="$month/tei:idno">
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

  <xsl:template match="tei:rs">
    <xsl:call-template name="field_index_instance_location" />
  </xsl:template>

</xsl:stylesheet>
