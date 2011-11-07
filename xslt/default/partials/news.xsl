<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "../entities.dtd">
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
	<!-- NEW -->
	<!-- news new -->
	<xsl:template match="module[@name='news' and @action='new']" mode="p-module">
		<xsl:apply-templates select="." mode="p-news-new" />
	</xsl:template>
	<!-- news form -->
	
	
	<!-- LISTS -->
	<!-- news list with 2 columnss -->
	<xsl:template match="module[@name='news' and @action='list' and @mode='columns']" mode="p-module">
		<table cellpadding="0" cellspacing="0" border="1">
			<xsl:apply-templates select="news" mode="p-news-list-columns"/>
		</table>
	</xsl:template>
	<!-- news list with 1 columnss -->
	<xsl:template match="module[@name='news' and @action='list' and not(@mode)]" mode="p-module">
		<xsl:apply-templates select="news" mode="p-news-list"/>
	</xsl:template>
	<!-- 2 columns -->
	<xsl:template match="*" mode="p-news-list-columns">
		<xsl:param name="pos" select="1" />
		<xsl:apply-templates select="." mode="p-news-list-columns-tr">
			<xsl:with-param name="item1" select="item[position() = $pos]"/>
			<xsl:with-param name="item2" select="item[position() = $pos+1]"/>
		</xsl:apply-templates>
		<xsl:if test="item[position() = $pos+2]">
			<xsl:apply-templates select="." mode="p-news-list-columns">
				<xsl:with-param name="pos" select="$pos+2"/>
			</xsl:apply-templates>
		</xsl:if>
		
	</xsl:template>
	<!-- one tr for column-->
	<xsl:template match="*" mode="p-news-list-columns-tr">
		<xsl:param name="item1"/>
		<xsl:param name="item2"/>
		<tr>
			<td width="50%">
				<xsl:apply-templates select="$item1" mode="p-news-item"/>
			</td>
			<td width="50%">
				<xsl:apply-templates select="$item2" mode="p-news-item"/>
			</td>
		</tr>
	</xsl:template>
	<!-- news item -->
	<xsl:template match="*" mode="p-news-item">
		<div>
			<div class="right_news">
				<div class="newssubblock">
					<a href="{@path}" title="{@title}" onfocus="this.blur()">
						<img border="0" alt="{@title}" src="{@image}" />
						<span class="comcount">
							<xsl:value-of select="@comment_count" />
							<xsl:text>&nbsp;комментариев&nbsp;</xsl:text>
						</span>
					</a>
				</div>
				<div class="newsrightblock">
					<div class="newstitle">
						<h2>
							<a href="{@path}">
								<xsl:value-of select="@date"/>
							</a>
						</h2>
					</div>
					<div class="newsdate">
						<xsl:value-of select="@date"/>
					</div>
					<div class="newsshorttext_main">
						<xsl:value-of select="@anons" disable-output-escaping="yes"/>
					</div>
				</div>
				<br clear="all" />
				<br />
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>
