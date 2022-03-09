<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Convert a bibliography authority TEI document to a concordance
       index. -->

  <xsl:template match="arr[@name='concordance_bibliography_item']">
    <td>
      <ul class="inline-list">
        <xsl:apply-templates select="str" />
      </ul>
    </td>
  </xsl:template>

  <xsl:template match="doc" mode="item-display">
    <tr>
      <xsl:apply-templates select="str[@name='concordance_bibliography_cited_range']" />
      <xsl:apply-templates select="arr[@name='concordance_bibliography_item']" />
    </tr>
  </xsl:template>
  
  <xsl:template match="doc" mode="bibl-list">  
    <xsl:variable name="bibl-id" select="str[@name='concordance_bibliography_ref']" />
        <xsl:choose>
          <!-- the following condition ensures that each bibliographic reference is displayed just once in the bibl. list -->
      <xsl:when test="str[@name='concordance_bibliography_listed']">
            <tr>
          <td><xsl:value-of select="str[@name='concordance_bibliography_date']"/></td>
          <td>
              <xsl:choose>
                <xsl:when test="str[@name='concordance_bibliography_cited_range']">
                  <a href="{kiln:url-for-match('local-concordance-bibliography-item', ($language, $bibl-id), 0)}">
                    <xsl:apply-templates mode="short-citation" select="id($bibl-id)"/>
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates mode="short-citation" select="id($bibl-id)"/>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:text>: </xsl:text>
              <xsl:apply-templates mode="full-citation" select="id($bibl-id)" />
          </td>
        </tr>
          </xsl:when>
        <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="str[@name='concordance_bibliography_cited_range']">
    <td>
      <xsl:value-of select="." />
    </td>
  </xsl:template>

  <xsl:template match="arr[@name='concordance_bibliography_item']/str">
    <li>
      <a href="{kiln:url-for-match('local-epidoc-display-html', ($language, .), 0)}">
        <xsl:value-of select="." />
      </a>
    </li>
  </xsl:template>

  <xsl:template match="tei:bibl[@xml:id]" mode="full-citation">
    <xsl:apply-templates select="node() except tei:bibl[@type]" />
    <!--<xsl:apply-templates select="tei:author" />
    <xsl:apply-templates select="tei:editor" />
    <xsl:apply-templates select="tei:date[1]" />
    <xsl:apply-templates select="tei:title[1]" />
    <xsl:apply-templates select="tei:title[2]" />-->
  </xsl:template>

  <xsl:template match="tei:bibl[@xml:id]" mode="short-citation">
    <strong>
      <xsl:choose>
        <xsl:when test="tei:bibl[@type='abbrev']">
          <xsl:apply-templates select="tei:bibl[@type='abbrev'][1]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="ancestor::tei:div[@xml:id='authored_editions']">
              <xsl:for-each select="descendant::tei:name[@type='surname'][not(parent::*/preceding-sibling::tei:title)]">
                <xsl:value-of select="."/>
                <xsl:if test="position()!=last()"> – </xsl:if>
              </xsl:for-each>
              <xsl:if test="descendant::tei:date/text()"><xsl:text> </xsl:text>
                <xsl:value-of select="descendant::tei:date"/></xsl:if>
            </xsl:when>
            <xsl:when test="ancestor::tei:div[@xml:id='series_collections']">
              <i><xsl:value-of select="@xml:id"/></i>
            </xsl:when>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </strong>
    <!--<xsl:choose>
      <xsl:when test="tei:editor">
        <xsl:value-of select="tei:editor[1]" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="tei:author[1]" />
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> </xsl:text>
    <xsl:value-of select=".//tei:date[1]" />-->
  </xsl:template>

  <xsl:template match="tei:bibl[@type='abbrev']">
    <xsl:value-of select="." />
  </xsl:template>
  
  <xsl:template match="tei:title">
    <i><xsl:value-of select="." /></i>
  </xsl:template>
  
  <xsl:template match="tei:ref[@target]">
    <a target="_blank" href="{@target}"><xsl:value-of select="." /></a>
  </xsl:template>
  
  <xsl:template match="tei:ptr[@target]">
    <xsl:choose>
      <xsl:when test="starts-with(@target, 'http')">
        <a target="_blank" href="{@target}"><xsl:value-of select="@target" /></a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="id">
          <xsl:choose>
            <xsl:when test="contains(@target, '#')">
              <xsl:value-of select="substring-after(@target, '#')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@target"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="bibl" select="ancestor::tei:TEI//tei:bibl[@xml:id=$id]"/>
        <a target="_blank" href="../../concordance/bibliography/{$id}.html">
          <xsl:choose>
            <xsl:when test="$bibl">
              <xsl:choose>
                <xsl:when test="$bibl//tei:bibl[@type='abbrev']">
                  <xsl:apply-templates select="$bibl//tei:bibl[@type='abbrev'][1]"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="$bibl[ancestor::tei:div[@xml:id='authored_editions']]">
                      <xsl:for-each select="$bibl//tei:name[@type='surname'][not(parent::*/preceding-sibling::tei:title)]">
                        <xsl:value-of select="."/>
                        <xsl:if test="position()!=last()"> – </xsl:if>
                      </xsl:for-each>
                      <xsl:if test="$bibl//tei:date/text()"><xsl:text> </xsl:text>
                        <xsl:value-of select="$bibl//tei:date"/></xsl:if>
                    </xsl:when>
                    <xsl:when test="$bibl[ancestor::tei:div[@xml:id='series_collections']]">
                      <i><xsl:value-of select="$bibl/@xml:id"/></i>
                    </xsl:when>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="upper-case(substring($id, 1, 1))" />
              <xsl:value-of select="substring($id, 2)" />
            </xsl:otherwise>
          </xsl:choose>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!--<xsl:template match="tei:author">
    <xsl:value-of select="." />
    <xsl:if test="following-sibling::tei:author">
      <xsl:text>,</xsl:text>
    </xsl:if>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template match="tei:editor">
    <xsl:value-of select="." />
    <xsl:choose>
      <xsl:when test="following-sibling::tei:editor">
        <xsl:text>, </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> (ed</xsl:text>
        <xsl:if test="preceding-sibling::tei:editor">
          <xsl:text>s</xsl:text>
        </xsl:if>
        <xsl:text>) </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="tei:title[1]">
    <xsl:text>, </xsl:text>
    <xsl:value-of select="." />
  </xsl:template>
  
  <xsl:template match="tei:title[2]">
    <xsl:choose>
      <xsl:when test="@level='j'">
        <xsl:text>, </xsl:text>
        <xsl:value-of select="." />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>, in </xsl:text>
        <xsl:value-of select="." />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>-->

</xsl:stylesheet>
