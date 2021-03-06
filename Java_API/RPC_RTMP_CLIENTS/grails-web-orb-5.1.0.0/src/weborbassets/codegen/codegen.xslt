<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  	<xsl:import href="codegen.project.eclipse.flex.xslt" />

	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />


	<xsl:template name="codegen.code" />
	<xsl:template name="codegen.code.class" />

	<xsl:template name="codegen.info" />
        <xsl:template name="codegen.appmain" />

	<xsl:template name="codegen.file.comment" />
	<xsl:template name="codegen.project.custom" />

  	<xsl:template name="codegen.project.eclipse.flex.actionscript.properties.applications">
  		<application path="main.mxml" />
  	</xsl:template>

	<xsl:template name="codegen.project.eclipse.flex.actionscript.properties.mainApplicationPath">main.mxml</xsl:template>

	<xsl:template name="codegen.project.eclipse.flex.name"><xsl:value-of select="//service/@name" /></xsl:template>

	<xsl:template name="codegen.process.fullproject">
<folder name="src">
	<xsl:for-each select="/namespaces">
		<xsl:call-template name="codegen.process.namespace" />
	</xsl:for-each>
 	<xsl:call-template name="codegen.appmain"/>
</folder>
		<xsl:call-template name="codegen.project.eclipse.flex" />
		<xsl:call-template name="codegen.project.eclipse.flex.properties" />
		<xsl:call-template name="codegen.project.eclipse.flex.actionscript.properties" />
		<xsl:call-template name="codegen.project.custom" />
	</xsl:template>

	<xsl:template match="/">
		<folder name="weborb-codegen">
			<info>
				<xsl:call-template name="codegen.info" />
			</info>

			<xsl:if test="//runtime/@generationMode = 'SHORT'">
				<xsl:for-each select="/namespaces">
					<xsl:call-template name="codegen.process.namespace" />
				</xsl:for-each>

			</xsl:if>



			<xsl:if test="//runtime/@generationMode != 'SHORT'">
				<xsl:call-template name="codegen.process.fullproject" />
			</xsl:if>
		</folder>
	</xsl:template>



  <xsl:template name="codegen.datatypeinitializer">
    <xsl:if test="count(//datatype) != 0">
      <file name="DataTypeInitializer.as">
        <xsl:call-template name="codegen.datatypelist">
          <xsl:with-param name="namespaceName" select="@namespace" />
        </xsl:call-template>
      </file>
    </xsl:if>
  </xsl:template>

  <xsl:template name="codegen.datatypelist">
	<xsl:param name="subnamespace" select="string('.vo.')" />
    <xsl:param name="namespaceName" />
    /*****************************************************************
    *
    *  To force the compiler to include all the generated complex types
    *  into the compiled application, add the following line of code
    *  into the main function of your Flex application:
    *
    *  new <xsl:value-of select="$namespaceName" />.DataTypeInitializer();
    *
    ******************************************************************/
    package <xsl:value-of select="$namespaceName" />
    {
      <xsl:for-each select="//datatype">
      import <xsl:value-of select="../@fullname" /><xsl:value-of select="$subnamespace"/><xsl:value-of select="@name"/>;</xsl:for-each>

      public class DataTypeInitializer
      {
        public function DataTypeInitializer()
        {
        <xsl:for-each select="//datatype">new <xsl:value-of select="../@fullname" /><xsl:value-of select="$subnamespace"/><xsl:value-of select="@name"/>();
        </xsl:for-each>
        }
      }
    }
  </xsl:template>


	<xsl:template name="codegen.process.namespace">
		<xsl:for-each select="namespace">
			<folder name="{@name}">
				<xsl:call-template name="codegen.process.namespace" />
				<xsl:for-each select="service">
					<xsl:call-template name="codegen.service" />
				</xsl:for-each>
				 <xsl:call-template name="codegen.vo.folder" />
			</folder>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="codegen.vo">
		<xsl:param name="version" select="3" />

		<file name="{@name}.as">
			<xsl:call-template name="codegen.description">
				<xsl:with-param name="file-name" select="concat(@name,'.as')" />
			</xsl:call-template>
			<xsl:if test="$version=3">
	package <xsl:value-of select="../@fullname" />.<xsl:choose>
    <xsl:when test="//runtime/@codeFormatType = 4">model</xsl:when>
    <xsl:when test="//runtime/@codeFormatType = 8">model.vo</xsl:when>
    <xsl:otherwise>vo</xsl:otherwise></xsl:choose>
    {
    import flash.utils.ByteArray;
    <xsl:call-template name="codegen.vo.specialinclusions" />
    <xsl:call-template name="codegen.import.fieldtypes" />
    <xsl:if test="@parentName">
    import <xsl:value-of select="@parentNamespace"/>.<xsl:choose>
      <xsl:when test="//runtime/@codeFormatType = 4">model.</xsl:when>
      <xsl:when test="//runtime/@codeFormatType = 8">model.vo.</xsl:when>
      <xsl:otherwise>vo.</xsl:otherwise></xsl:choose><xsl:value-of select="@parentName"/>;
	</xsl:if>

    [Bindable]
    [RemoteClass(alias="<xsl:value-of select='@fullname' />")]
    </xsl:if>
  <xsl:if test='$version=3'>public</xsl:if> class <xsl:choose>
			    <xsl:when test='$version=3'>
				    <xsl:value-of select="@name" /><xsl:if test="@parentName"> extends <xsl:value-of select="@parentNamespace"/>.<xsl:choose>
            <xsl:when test="//runtime/@codeFormatType = 4">model.</xsl:when>
            <xsl:when test="//runtime/@codeFormatType = 8">model.vo.</xsl:when>
            <xsl:otherwise>vo.</xsl:otherwise></xsl:choose><xsl:value-of select="@parentName"/></xsl:if>
					</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="//service/@namespace" />.<xsl:choose>
          <xsl:when test="//runtime/@codeFormatType = 4">model.</xsl:when>
          <xsl:when test="//runtime/@codeFormatType = 8">model.vo.</xsl:when>
          <xsl:otherwise>vo.</xsl:otherwise></xsl:choose><xsl:value-of select="@name" />
				</xsl:otherwise>
			</xsl:choose>
    {
       public function <xsl:value-of select="@name" />(){}

			<xsl:if test="count(field) = 0">
       // This class is empty, because it doesn't contain
       // any public fields or bean properties.
			</xsl:if>
			<xsl:for-each select="field">
       <xsl:variable name="fulltype" select="@fulltype"/>
       public<xsl:call-template name="codegen.add.override.if.needed"/> var <xsl:value-of select="@name" />:<xsl:if test="@typeNamespace"><xsl:value-of select="@typeNamespace" />.<xsl:choose>
        <xsl:when test="//runtime/@codeFormatType = 4">model.<xsl:if test="//enum[@fullname=$fulltype]">enum.</xsl:if></xsl:when>
        <xsl:when test="//runtime/@codeFormatType = 8">model.vo.<xsl:if test="//enum[@fullname=$fulltype]">enum.</xsl:if></xsl:when>
        <xsl:otherwise><xsl:choose>
          <xsl:when test="//enum[@fullname=$fulltype]">enum.</xsl:when><xsl:otherwise>vo.</xsl:otherwise></xsl:choose></xsl:otherwise></xsl:choose></xsl:if><xsl:value-of select="@type" />;
			</xsl:for-each>
    }
  <xsl:if test="$version=3">}
			</xsl:if>
		</file>
	</xsl:template>

<xsl:template name="codegen.vo.specialinclusions">
    import mx.collections.ArrayCollection;
</xsl:template>

  <xsl:template name="codegen.enum">
    <xsl:param name="version" select="3" />

    <file name="{@name}.as">
      <xsl:call-template name="codegen.description">
        <xsl:with-param name="file-name" select="concat(@name,'.as')" />
      </xsl:call-template>
      <xsl:if test="$version=3">
        package <xsl:value-of select="../@fullname" />.<xsl:choose>
    <xsl:when test="//runtime/@codeFormatType = 4">model.</xsl:when>
    <xsl:when test="//runtime/@codeFormatType = 8">model.vo.</xsl:when>
    </xsl:choose>enum
        {
      </xsl:if>
      <xsl:if test='$version=3'>  public</xsl:if> class <xsl:choose>
          <xsl:when test='$version=3'>
            <xsl:value-of select="@name"/> <xsl:if test="@parentName"> extends <xsl:value-of select="@parentNamespace"/>.vo.<xsl:value-of select="@parentName"/></xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="//service/@namespace"/>.vo.<xsl:value-of select="@name"/>
          </xsl:otherwise></xsl:choose>
        {
          public function <xsl:value-of select="@name"/>(){}

        <xsl:for-each select="field">
          public<xsl:call-template name="codegen.add.override.if.needed"/> static var <xsl:value-of select="@name"/>:String="<xsl:value-of select="@name"/>";
        </xsl:for-each>
        }
      <xsl:if test="$version=3">
      }
      </xsl:if>
    </file>
  </xsl:template>


  <xsl:template name="codegen.add.override.if.needed">
    <xsl:param name="field-name" select="''"/>
    <xsl:variable name="parentName" select="../@parentName"/>
    <xsl:variable name="parentNamespace" select="../@parentNamespace"/>
    <xsl:variable name="name" select="@name"/>
    <xsl:choose>
      <xsl:when test="$field-name != '' and $parentName and //datatype[@name = $parentName and @typeNamespace = $parentNamespace]/field/@name = $field-name"> override</xsl:when>
      <xsl:when test="$field-name = '' and $parentName and //datatype[@name = $parentName and @typeNamespace = $parentNamespace]/field/@name = $name"> override</xsl:when>
      <xsl:when test="$parentName and //datatype[@name = $parentName and @typeNamespace = $parentNamespace]/@parentName">
        <xsl:for-each select="//datatype[@name = $parentName and @typeNamespace = $parentNamespace]/field">
          <!--
              Need to call codegen.add.override.if.needed template only one time
              The following xslt can not be used  <xsl:for-each select="//datatype[@name = $parentName and @typeNamespace = $parentNamespace]/field[@name=$field-name]">
                because parent could not have this field but parent of parent could
          -->
          <xsl:if test="position() = 1">
            <xsl:choose>
              <xsl:when test="$field-name = ''">
                <xsl:call-template name="codegen.add.override.if.needed">
                  <xsl:with-param name="field-name" select="$name"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="codegen.add.override.if.needed">
                  <xsl:with-param name="field-name" select="$field-name"/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="codegen.vo.folder">
		<xsl:param name="version" select="3" />
		<xsl:if test="count(datatype) != 0">
			<folder name="vo">
				<xsl:for-each select="datatype">
					<xsl:call-template name="codegen.vo">
						<xsl:with-param name="version" select="$version" />
					</xsl:call-template>
				</xsl:for-each>
			</folder>
		</xsl:if>
		<xsl:if test="count(enum) != 0">
      		<folder name="enum">
        		<xsl:for-each select="enum">
          		<xsl:call-template name="codegen.enum">
            		<xsl:with-param name="version" select="$version" />
          		</xsl:call-template>
        	</xsl:for-each>
      		</folder>
    </xsl:if>
	</xsl:template>

	<xsl:template name="codegen.service">
		<xsl:call-template name="codegen.vo.folder" />
		<file name="{concat(@name,'.as')}">
			<xsl:call-template name="codegen.description">
				<xsl:with-param name="file-name" select="concat(@name,'.as')" />
			</xsl:call-template>
			<xsl:call-template name="codegen.code" />
		</file>
		<xsl:call-template name="codegen.datatypeinitializer" />
	</xsl:template>

	<xsl:template name="codegen.import.alltypes">
    	<xsl:param name="excludeNamespace" select="''" />
        <xsl:param name="subnamespace" select="''" />
    	<xsl:for-each select="//namespace/datatype[@typeNamespace!=$excludeNamespace]">
    import <xsl:value-of select="@typeNamespace" /><xsl:if test="$subnamespace != ''">.<xsl:value-of
              select="$subnamespace" /></xsl:if>.<xsl:value-of select="@name"/>;</xsl:for-each>
    	<xsl:for-each select="//namespace/enum[@typeNamespace!=$excludeNamespace]">
    import <xsl:value-of select="@typeNamespace" /><xsl:if test="$subnamespace != ''"><xsl:if
              test="//runtime/@codeFormatType = 4 or //runtime/@codeFormatType = 8">.<xsl:value-of select="$subnamespace"/></xsl:if>.enum</xsl:if>.<xsl:value-of select="@name"/>;</xsl:for-each>
	</xsl:template>

  <xsl:template name="codegen.import.fieldtypes">
      <xsl:param name="subnamespace" select="''" />
    <xsl:for-each select="field">
	  <xsl:variable name="fulltype" select = "@fulltype" />
      <xsl:if test="@typeNamespace">
	    <xsl:if test="count(//namespace/datatype[@fullname=$fulltype]) != 0">
		import <xsl:value-of select="@typeNamespace" /><xsl:if test="$subnamespace != ''">.<xsl:value-of
                select="$subnamespace" /></xsl:if>.<xsl:choose>
    <xsl:when test="//runtime/@codeFormatType = 4">model.</xsl:when>
    <xsl:when test="//runtime/@codeFormatType = 8">model.vo.</xsl:when>
    <xsl:otherwise>vo.</xsl:otherwise></xsl:choose><xsl:value-of select="@type"/>;
	   </xsl:if>
	    <xsl:if test="count(//namespace/enum[@fullname=$fulltype]) != 0">
		import <xsl:value-of select="@typeNamespace" /><xsl:if test="$subnamespace != ''">.<xsl:value-of
                select="$subnamespace" /></xsl:if>.<xsl:choose>
    <xsl:when test="//runtime/@codeFormatType = 4">model.</xsl:when>
    <xsl:when test="//runtime/@codeFormatType = 8">model.vo.</xsl:when>
    </xsl:choose>enum.<xsl:value-of select="@type"/>;
	   </xsl:if>
	 </xsl:if>
    </xsl:for-each>
  </xsl:template>

	<xsl:template name="codegen.description">
		<xsl:param name="file-name" />
  /*******************************************************************
  * <xsl:value-of select="$file-name" />
  * Copyright (C) 2006-2011 Midnight Coders, Inc.
  *
  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
  * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
  * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
  * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
  * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
  * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  ********************************************************************/
		<xsl:call-template name="codegen.file.comment" />
	</xsl:template>

	<xsl:template name="replace">
       <xsl:param name="input"/>
       <xsl:param name="from"/>
       <xsl:param name="to"/>

       <xsl:choose>
           <xsl:when test="contains($input, $from)">
               <xsl:value-of select="substring-before($input, $from)"/>
               <xsl:value-of select="$to"/>
               <xsl:call-template name="replace">
                   <xsl:with-param name="input" select="substring-after($input, $from)"/>
                   <xsl:with-param name="from" select="$from"/>
                   <xsl:with-param name="to" select="$to"/>
               </xsl:call-template>
           </xsl:when>
           <xsl:otherwise>
               <xsl:value-of select="$input"/>
           </xsl:otherwise>
       </xsl:choose>
   </xsl:template>

<xsl:template name="string-replace-all">
    <xsl:param name="text" />
    <xsl:param name="replace" />
    <xsl:param name="by" />
    <xsl:choose>
      <xsl:when test="contains($text, $replace)">
        <xsl:value-of select="substring-before($text,$replace)" />
        <xsl:value-of select="$by" />
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text"
          select="substring-after($text,$replace)" />
          <xsl:with-param name="replace" select="$replace" />
          <xsl:with-param name="by" select="$by" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet> 