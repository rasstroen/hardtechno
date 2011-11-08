<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "../entities.dtd">
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
	<!-- NEW -->
	<!-- releases new -->
	<xsl:template match="module[@name='releases' and @action='new']" mode="p-module">
		<xsl:apply-templates select="." mode="p-releases-new" />
	</xsl:template>
	<!-- releases form -->
	
	
	<!-- LISTS -->
	<!-- releases list with 2 columnss -->
	<xsl:template match="module[@name='releases' and @action='list' and @mode='columns']" mode="p-module">
		<table cellpadding="0" cellspacing="0" border="1">
			<xsl:apply-templates select="releases" mode="p-releases-list-columns"/>
		</table>
	</xsl:template>
	<!-- releases list with 1 columnss -->
	<xsl:template match="module[@name='releases' and @action='list' and not(@mode)]" mode="p-module">
		<xsl:apply-templates select="releases" mode="p-releases-list"/>
	</xsl:template>
	<!-- 2 columns -->
	<xsl:template match="*" mode="p-releases-list-columns">
		<xsl:param name="pos" select="1" />
		<xsl:apply-templates select="." mode="p-releases-list-columns-tr">
			<xsl:with-param name="item1" select="item[position() = $pos]"/>
			<xsl:with-param name="item2" select="item[position() = $pos+1]"/>
		</xsl:apply-templates>
		<xsl:if test="item[position() = $pos+2]">
			<xsl:apply-templates select="." mode="p-releases-list-columns">
				<xsl:with-param name="pos" select="$pos+2"/>
			</xsl:apply-templates>
		</xsl:if>
		
	</xsl:template>
	<!-- one tr for column-->
	<xsl:template match="*" mode="p-releases-list-columns-tr">
		<xsl:param name="item1"/>
		<xsl:param name="item2"/>
		<tr>
			<td width="50%">
				<xsl:apply-templates select="$item1" mode="p-releases-item"/>
			</td>
			<td width="50%">
				<xsl:apply-templates select="$item2" mode="p-releases-item"/>
			</td>
		</tr>
	</xsl:template>
	<!-- releases item -->
	<xsl:template match="*" mode="p-releases-item">
		<div>
			<div class="right_releases">
				<div class="releasessubblock">
					<a href="{@path}" title="{@title}" onfocus="this.blur()">
						<img border="0" alt="{@title}" src="{@image}" />
						<span class="comcount">
							<xsl:value-of select="@comment_count" />
							<xsl:text>&nbsp;комментариев&nbsp;</xsl:text>
						</span>
					</a>
				</div>
				<div class="releasesrightblock">
					<div class="releasestitle">
						<h2>
							<a href="{@path}">
								<xsl:value-of select="@date"/>
							</a>
						</h2>
					</div>
					<div class="releasesdate">
						<xsl:value-of select="@date"/>
					</div>
					<div class="releasesshorttext_main">
						<xsl:value-of select="@anons" disable-output-escaping="yes"/>
					</div>
				</div>
				<br clear="all" />
				<br />
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>
