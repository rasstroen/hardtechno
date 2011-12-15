<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "entities.dtd">
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
	<xsl:output omit-xml-declaration="yes"/>
	<xsl:output indent="yes"/>

  <xsl:template match="*" mode="h-lang_code-select">
    <xsl:variable select="lang_id" name="lang_id"/>
		<select name="lang_code" class="h-lang_code-select">
			<xsl:for-each select="lang_codes/item">
				<option value="{@code}">
          <xsl:if test="($lang_id=@id) or (not($lang_id) and @code='ru')"><xsl:attribute name="selected"/></xsl:if>
          <xsl:value-of select="@title"/> (<xsl:value-of select="@code"/>)
				</option>
			</xsl:for-each>
		</select>
		<input name="lang_code" class="h-lang_code-input" value="{@lang_code}" />
		<script>$('.h-lang_code-select').change(function(){$(".h-lang_code-input").val($(this).val());});</script>
  </xsl:template>

  <xsl:template match="*" mode="h-rightholders-select">
		<select name="lang_code" class="h-rightholders-select">
      <xsl:variable name="id_rightholder" select="@id"/>
			<xsl:for-each select="rightholders/item">
				<option value="{@id}">
          <xsl:if test="@id_rightholder=$id_rightholder"><xsl:attribute name="selected"/></xsl:if>
          <xsl:value-of select="@title"/>
				</option>
			</xsl:for-each>
		</select>
  </xsl:template>

	<xsl:template name="helpers-role-select">
		<xsl:param name="object" select="book"/>
		<select name="role" class="role-select">
			<xsl:for-each select="$object/roles/item">
				<option value="{@id}">
					<xsl:value-of select="@title"/>
				</option>
			</xsl:for-each>
		</select>
	</xsl:template>

	<xsl:template name="helpers-relation-type-select">
		<xsl:param name="object" select="book"/>
		<select name="relation_type" class="relation_type-select">
			<xsl:for-each select="$object/relation_types/item">
				<option value="{@id}">
					<xsl:value-of select="@name"/>
				</option>
			</xsl:for-each>
		</select>
	</xsl:template>

	<xsl:template name="helpers-this-amount">
		<xsl:param name="amount"/>
		<xsl:param name="words"/>
		<xsl:variable name="mod10" select="$amount mod 10"/>
		<xsl:variable name="f5t20" select="$amount>=5 and not($amount>20)"/>
    <xsl:value-of select="$amount"/>
    <xsl:text>&nbsp;</xsl:text>
		<xsl:choose>
			<xsl:when test="not($f5t20) and $mod10=1">
				<xsl:value-of select="substring-before($words,' ')"/>
			</xsl:when>
			<xsl:when test="not($f5t20) and (not($mod10>5) and $mod10>1)">
				<xsl:value-of select="substring-before(substring-after($words,' '),' ')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring-after(substring-after($words,' '),' ')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="helpers-abbr-time">
		<xsl:param name="time"/>
		<xsl:if test="$time">
			<abbr class="timeago" title="{$time}">
				<xsl:value-of select="$time"/>
			</abbr>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="helpers-book-link">
    <a href="{@path}">
			<xsl:value-of select="@title"/>
		</a>
	</xsl:template>

	<xsl:template match="*" mode="helpers-file-link">
    <a href="{@path}">
      <xsl:value-of select="@filetypedesc"/>, <xsl:apply-templates select="." mode="helpers-file-size"/>
		</a>
	</xsl:template>

  <xsl:template match="*" mode="helpers-file-size">
    <xsl:variable select="@size div 1024" name="kb"/>
    <xsl:variable select="$kb div 1024" name="mb"/>
    <xsl:choose>
      <xsl:when test="$mb > 1">
        <xsl:value-of select="round(100*$mb) div 100"/> МБ
      </xsl:when>
      <xsl:when test="$kb > 1">
        <xsl:value-of select="round($kb)"/> КБ
      </xsl:when>
    	<xsl:otherwise></xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$mb > 1">
    </xsl:if>
  </xsl:template>

	<xsl:template match="*" mode="helpers-book-cover">
    <a href="{@path}">
      <img src="{@cover}?{@lastSave}" alt="[{@title}]" />
		</a>
	</xsl:template>

	<xsl:template name="helpers-author-name">
		<xsl:param name="author" select="author"/>
		<xsl:value-of select="$author/@first_name"/>
		<xsl:if test="$author/@middle_name!=''">
			<xsl:text> </xsl:text>
			<xsl:value-of select="$author/@middle_name"/>
		</xsl:if>
		<xsl:if test="($author/@middle_name!='') or ($author/@first_name!='')">
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:value-of select="$author/@last_name"/>
	</xsl:template>

	<xsl:template match="*" mode="helpers-author-link">
		<a href="{@path}">
      <xsl:call-template name="helpers-author-name">
        <xsl:with-param select="." name="author"/>
      </xsl:call-template>
		</a>
	</xsl:template>

	<xsl:template match="*" mode="helpers-author-image">
		<a href="{@path}">
      <img src="{@picture}?{@lastSave}" alt="[{@name}]" />
		</a>
	</xsl:template>

	<xsl:template match="*" mode="helpers-user-link">
		<a href="{@path}">
			<xsl:value-of select="@nickname"/>
		</a>
	</xsl:template>

	<xsl:template match="*" mode="helpers-user-image">
		<a href="{@path}">
      <img src="{@picture}?{@lastSave}" alt="[{@nickname}]" title="{@nickname}"/>
		</a>
	</xsl:template>

	<xsl:template match="*" mode="helpers-genre-link">
		<a href="{@path}">
			<xsl:value-of select="@title"/>
		</a>
	</xsl:template>

	<xsl:template match="*" mode="helpers-serie-link">
		<a href="{@path}">
			<xsl:value-of select="@title"/>
		</a>
	</xsl:template>

	<xsl:template match="*" mode="helpers-magazine-link">
		<a href="{@path}">
			<xsl:value-of select="@title"/>
		</a>
	</xsl:template>

  <xsl:template match="*" mode="helpers-variant-link">
		<a href="{@path}">
			<xsl:value-of select="@title"/>
		</a>
  </xsl:template>

  <xsl:template match="*" mode="h-stylesheet">
    <xsl:variable name="path" select="concat(&prefix;,'static/default/css/',@path,'.css')"/>
    <link href="{$path}" media="screen" rel="stylesheet" type="text/css"/>
  </xsl:template>

  <xsl:template match="*" mode="h-javascript">
    <xsl:variable name="path" select="concat(&prefix;,'static/default/js/',@path,'.js')"/>
    <script src="{$path}" type="text/javascript"></script>
  </xsl:template>

  <xsl:template match="*" mode="h-action-names">
    <xsl:param name="object" select="''"/>
    <xsl:choose>
      <xsl:when test="$object='contribution'">
        <xsl:choose>
          <xsl:when test="@action='authors_add'">Добавил нового автора</xsl:when>
          <xsl:when test="@action='authors_edit'">Отредактировал автора</xsl:when>
          <xsl:when test="@action='books_add'">Добавил новую книгу</xsl:when>
          <xsl:when test="@action='books_add_cover'">Загрузил обложку книги</xsl:when>
          <xsl:when test="@action='books_edit_cover'">Обновил обложку книги</xsl:when>
          <xsl:when test="@action='books_edit'">Изменил книгу</xsl:when>
          <xsl:when test="@action='genres_add'">Добавил новую серию</xsl:when>
          <xsl:when test="@action='ocr_add'">Внёс вклад в работу над книгой</xsl:when>
          <xsl:when test="@action='reviews_add'">Даписал рецензию на книгу</xsl:when>
          <xsl:when test="@action='series_add'">Добавил новую серию</xsl:when>
          <xsl:when test="@action='series_concat'">Склеил серии</xsl:when>
          <xsl:when test="@action='series_edit'">Отредактировал серию</xsl:when>
          <xsl:otherwise/>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="@action='authors_add'">добавил нового автора</xsl:when>
          <xsl:when test="@action='authors_add_picture'">загрузил фото автора</xsl:when>
          <xsl:when test="@action='authors_add_duplicate'">указал дубликат автора</xsl:when>
          <xsl:when test="@action='authors_add_relation'">указал перевод автора</xsl:when>
          <xsl:when test="@action='authors_delete_duplicate'">удалил дубликат автора</xsl:when>
          <xsl:when test="@action='authors_delete_relation'">удалил перевод автора</xsl:when>
          <xsl:when test="@action='authors_edit'">отредактировал автора</xsl:when>
          <xsl:when test="@action='authors_edit_picture'">обновил фото автора</xsl:when>
          <xsl:when test="@action='authors_edit_duplicate'">указал дубликат автора</xsl:when>
          <xsl:when test="@action='authors_edit_relation'">указал перевод автора</xsl:when>
          <xsl:when test="@action='books_add'">добавил новую книгу</xsl:when>
          <xsl:when test="@action='books_add_cover'">добавил обложку книги</xsl:when>
          <xsl:when test="@action='books_add_file'">загрузил файл книги</xsl:when>
          <xsl:when test="@action='books_add_author'">указал автора для книги</xsl:when>
          <xsl:when test="@action='books_add_genre'">указал жанр для книги</xsl:when>
          <xsl:when test="@action='books_add_serie'">добавил книгу в серию</xsl:when>
          <xsl:when test="@action='books_add_duplicate'">указал дубликат книги</xsl:when>
          <xsl:when test="@action='books_add_relation'">указал редакцию (перевод) книги</xsl:when>
          <xsl:when test="@action='books_delete_duplicate'">удалил дубликат книги</xsl:when>
          <xsl:when test="@action='books_delete_relation'">удалил редакцию (перевод) книги</xsl:when>
          <xsl:when test="@action='books_edit'">изменил книгу</xsl:when>
          <xsl:when test="@action='books_edit_authors'">изменил состав авторов книги</xsl:when>
          <xsl:when test="@action='books_edit_cover'">обновил обложку книги</xsl:when>
          <xsl:when test="@action='books_edit_genres'">изменил список жанров книги</xsl:when>
          <xsl:when test="@action='books_edit_series'">изменил список серий книги</xsl:when>
          <xsl:when test="@action='books_edit_file'">обновил файл для книги</xsl:when>
          <xsl:when test="@action='comments_add'">добавил комментарий</xsl:when>
          <xsl:when test="@action='genres_edit'">отредактировал жанр</xsl:when>
          <xsl:when test="@action='loved_add_author'">добавил в любимые автора</xsl:when>
          <xsl:when test="@action='loved_add_book'">добавил в любимые книгу</xsl:when>
          <xsl:when test="@action='loved_add_genre'">добавил в любимые жанр</xsl:when>
          <xsl:when test="@action='loved_add_serie'">добавил в любимые серию</xsl:when>
          <xsl:when test="@action='magazines_add'">добавил новый журнал</xsl:when>
          <xsl:when test="@action='magazines_add_cover'">загрузил обложку журнала</xsl:when>
          <xsl:when test="@action='magazines_edit'">отредактировал информацию о журнале</xsl:when>
          <xsl:when test="@action='magazines_edit_cover'">обновил обложку журнала</xsl:when>
          <xsl:when test="@action='ocr_add'">внёс вклад в работу над книгой</xsl:when>
          <xsl:when test="@action='posts_add'">написал пост</xsl:when>
          <xsl:when test="@action='reviews_add'">написал рецензию на книгу</xsl:when>
          <xsl:when test="@action='reviews_add_rate'">оценил книгу
            <xsl:if test="@mark">
              на <xsl:value-of select="@mark"/>
            </xsl:if>
          </xsl:when>
          <xsl:when test="@action='series_add'">добавил новую серию</xsl:when>
          <xsl:when test="@action='series_concat'">склеил серии</xsl:when>
          <xsl:when test="@action='series_edit'">отредактировал серию</xsl:when>
          <xsl:when test="@action='shelf_add_book'">добавил книгу на полку
            <xsl:if test="@shelf_title">
              «<xsl:value-of select="@shelf_title"/>»
            </xsl:if>
          </xsl:when>
          <xsl:when test="@action='users_add_friend'">добавил в друзья пользователя</xsl:when>
          <xsl:otherwise/>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*" mode="h-message">
    <div class="h-message"><xsl:value-of select="@html"/></div>
  </xsl:template>

  <xsl:template match="*" mode="h-statistics-period">
    <div class="h-statistics-period">
      <p class="h-statistics-period-variants">
        Статистика
        <xsl:text> </xsl:text><a href="{@current_month_path}">за текущий месяц</a>
        <xsl:text> </xsl:text><a href="{@last_month_path}">за прошедший месяц</a>
      </p>
      <p class="h-statistics-period-calendar">
        в период <label for="from">c</label><input id="from" name="from" value="{&page;/variables/@from}"/><label for="to">по</label><input id="to" name="to" value="{&page;/variables/@to}"/> <a href="#" class="m-statistics-list-period-show">показать</a>
      </p>
    </div>
  </xsl:template>

</xsl:stylesheet>
