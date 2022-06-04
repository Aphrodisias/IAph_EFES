<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../kiln/stylesheets/solr/tei-to-solr.xsl" />

  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Oct 18, 2010</xd:p>
      <xd:p><xd:b>Author:</xd:b> jvieira</xd:p>
      <xd:p>This stylesheet converts a TEI document into a Solr index document. It expects the parameter file-path,
      which is the path of the file being indexed.</xd:p>
    </xd:desc>
  </xd:doc>

  <xsl:template match="/">
    <add>
      <xsl:apply-imports />
    </add>
  </xsl:template>
  
  <xsl:template match="tei:rs[@type='textType']" mode="facet_inscription_type">
    <field name="inscription_type">
      <xsl:value-of select="upper-case(substring(normalize-space(translate(translate(translate(., '?', ''), '_', ' '), '/', '／')), 1, 1))" />
      <xsl:value-of select="substring(normalize-space(translate(translate(translate(., '?', ''), '_', ' '), '/', '／')), 2)" />
    </field>
  </xsl:template>
  
  <xsl:template match="tei:rs[@key]" mode="facet_mentioned_institutions">
    <field name="mentioned_institutions">
      <xsl:value-of select="@key"/>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:persName[@type='divine']" mode="facet_mentioned_divinities">
    <field name="mentioned_divinities">
      <xsl:value-of select="@key"/>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:persName/tei:name[@nymRef]" mode="facet_person_name">
    <field name="person_name">
      <xsl:value-of select="@nymRef"/>
    </field>
  </xsl:template>
  
  <!-- This template is called by the Kiln tei-to-solr.xsl as part of
       the main doc for the indexed file. Put any code to generate
       additional Solr field data (such as new facets) here. -->
  
  <xsl:template name="extra_fields">
    <xsl:call-template name="field_inscription_type"/>
    <xsl:call-template name="field_mentioned_institutions"/>
    <xsl:call-template name="field_mentioned_divinities"/>
    <xsl:call-template name="field_person_name"/>
  </xsl:template>
  
  <xsl:template name="field_inscription_type">
    <xsl:apply-templates mode="facet_inscription_type" select="/tei:TEI/tei:teiHeader/tei:profileDesc/tei:textClass/tei:keywords/tei:term//tei:rs[@type='textType']"/>
  </xsl:template>
  
  <xsl:template name="field_mentioned_institutions">
    <xsl:apply-templates mode="facet_mentioned_institutions" select="//tei:text/tei:body/tei:div[@type='edition']"/>
  </xsl:template>
  
   <xsl:template name="field_mentioned_divinities">
    <xsl:apply-templates mode="facet_mentioned_divinities" select="//tei:text/tei:body/tei:div[@type='edition']" />
  </xsl:template>
  
  <xsl:template name="field_person_name">
    <xsl:apply-templates mode="facet_person_name" select="//tei:text/tei:body/tei:div[@type='edition']" />
  </xsl:template>

</xsl:stylesheet>
