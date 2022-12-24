<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
    version="2.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <!-- This XSLT transforms a set of EpiDoc documents into a Solr
       index document representing an index of words in those
       documents. -->
    
    <xsl:import href="epidoc-index-utils.xsl" />
    
    <xsl:param name="index_type" />
    <xsl:param name="subdirectory" />
    
    
    <xsl:template name="ignore" mode="ignore" match="//tei:am | //tei:sic | //tei:orig | //tei:surplus | //tei:del[@rend='corrected']"/>
    <xsl:template match="/">
        <add>
            <xsl:for-each-group select="//tei:w[ancestor::tei:div/@type='edition']" group-by="normalize-unicode(normalize-space(replace(translate(., 'Ϲϲ', 'Σσ'), 'σ([:punct:]{1}|[:blank:]{1}|$)', 'ς$1')),'NFD')">
                <doc>
                    <field name="document_type">
                        <xsl:value-of select="$subdirectory" />
                        <xsl:text>_</xsl:text>
                        <xsl:value-of select="$index_type" />
                        <xsl:text>_index</xsl:text>
                    </field>
                    <xsl:call-template name="field_file_path" />
                    <field name="index_item_name">
                        <xsl:variable name="word"><xsl:apply-templates mode="ignore" select="."/></xsl:variable>
                    <xsl:value-of select="normalize-unicode(normalize-space(replace(translate($word, 'Ϲϲ', 'Σσ'), 'σ([:punct:]{1}|[:blank:]{1}|$)', 'ς$1')),'NFD')" />
                    </field>
                    <field name="language_code">
                        <xsl:value-of select="ancestor-or-self::*[@xml:lang][1]/@xml:lang"/>
                    </field>
                    <xsl:apply-templates select="current-group()" />
                </doc>
            </xsl:for-each-group>
        </add>
    </xsl:template>
    
    <xsl:template match="tei:w">
        <xsl:call-template name="field_index_instance_location" />
    </xsl:template>
    
</xsl:stylesheet>

