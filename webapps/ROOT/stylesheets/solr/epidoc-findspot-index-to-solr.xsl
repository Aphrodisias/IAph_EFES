<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- This XSLT transforms a set of EpiDoc documents into a Solr
       index document representing an index of findspots. -->

  <xsl:import href="epidoc-index-utils.xsl" />

  <xsl:param name="index_type" />
  <xsl:param name="subdirectory" />

  <xsl:template match="/">
    <add>
      <xsl:for-each-group select="//tei:provenance[@type='found']//tei:placeName[@type='ancientFindspot'][1]" group-by="concat(.,'-',@ref,'-',following-sibling::tei:placeName[not(@type)][1]/@ref,'-',following-sibling::tei:placeName[@type='monuList'][1],'-',following-sibling::tei:placeName[@type='monuList'][1]/@ref,'-',following-sibling::tei:placeName[@type='monuList'][2],'-',following-sibling::tei:placeName[@type='monuList'][2]/@ref,'-',following-sibling::tei:placeName[@type='monuList'][3],'-',following-sibling::tei:placeName[@type='monuList'][3]/@ref)">
        
        <xsl:variable name="lev1id">
          <xsl:choose>
            <xsl:when test="@ref">
              <xsl:value-of select="replace(@ref, '#', '')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="."/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="lev2id">
          <xsl:choose>
            <xsl:when test="following-sibling::tei:placeName[not(@type)][1][@ref]">
              <xsl:value-of select="replace(following-sibling::tei:placeName[not(@type)][1]/@ref, '#', '')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="following-sibling::tei:placeName[not(@type)][1]"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="placeAL" select="document('../../content/xml/authority/findspot.xml')"/>
        
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type" />
            <xsl:text>_index</xsl:text>
          </field>
          <xsl:call-template name="field_file_path" />
          
          <field name="index_findspot_upper_level">
            <xsl:choose>
              <xsl:when test="$placeAL//tei:place[@xml:id=$lev1id]">
                <xsl:value-of select="$placeAL//tei:place[@xml:id=$lev1id]/tei:placeName[1]"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$lev1id"/>
              </xsl:otherwise>
            </xsl:choose>
          </field>
          
          <field name="index_findspot_intermediate_level">
            <xsl:choose>
              <xsl:when test="following-sibling::tei:placeName[not(@type)]"> 
                <xsl:choose>
                  <xsl:when test="$placeAL//tei:place[@xml:id=$lev2id]">
                    <xsl:value-of select="$placeAL//tei:place[@xml:id=$lev2id]/tei:placeName[1]"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$lev2id"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>-</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </field>
          
          <field name="index_findspot_lower_level">
            <xsl:choose>
              <xsl:when test="following-sibling::tei:placeName[@type='monuList']">
                <xsl:for-each select="following-sibling::tei:placeName[@type='monuList']">
                  <xsl:variable name="lev3id">
                    <xsl:choose>
                      <xsl:when test="@ref">
                        <xsl:value-of select="replace(@ref, '#', '')"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="."/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:variable>
                  <xsl:choose>
                    <xsl:when test="$placeAL//tei:place[@xml:id=$lev3id]">
                      <xsl:value-of select="$placeAL//tei:place[@xml:id=$lev3id]/tei:placeName[1]"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="."/>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:if test="position()!=last()">; </xsl:if>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>-</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </field>
          
          
            <xsl:choose>
              <xsl:when test="following-sibling::tei:placeName[@type='monuList'][@ref]">
                <xsl:for-each select="following-sibling::tei:placeName[@type='monuList']/@ref">
                  <xsl:variable name="lev3id" select="replace(., '#', '')"/>
                  <xsl:for-each select="$placeAL//tei:place[@xml:id=$lev3id]/tei:idno">
                    <field name="index_external_resource"><xsl:value-of select="." /></field>
                  </xsl:for-each>
                </xsl:for-each>
              </xsl:when>
              <xsl:when test="following-sibling::tei:placeName[not(@type)][@ref] and $placeAL//tei:place[@xml:id=$lev2id]">
                <xsl:for-each select="$placeAL//tei:place[@xml:id=$lev2id]/tei:idno">
                  <field name="index_external_resource"><xsl:value-of select="." /></field>
                </xsl:for-each>
              </xsl:when>
              <xsl:when test="$placeAL//tei:place[@xml:id=$lev1id]">
                <xsl:for-each select="$placeAL//tei:place[@xml:id=$lev1id]/tei:idno">
                  <field name="index_external_resource"><xsl:value-of select="." /></field>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <field name="index_external_resource"><xsl:text>-</xsl:text></field>
              </xsl:otherwise>
            </xsl:choose>
          
          <xsl:apply-templates select="current-group()" />
        </doc>
      </xsl:for-each-group>
    </add>
  </xsl:template>

  <xsl:template match="tei:placeName[ancestor::tei:provenance[@type='found']]">
    <xsl:call-template name="field_index_instance_location" />
  </xsl:template>

</xsl:stylesheet>
