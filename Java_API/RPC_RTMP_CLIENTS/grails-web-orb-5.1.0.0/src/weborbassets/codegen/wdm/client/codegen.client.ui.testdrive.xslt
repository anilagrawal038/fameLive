<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
  xmlns:codegen="xalan://weborb.data.management.codegen.XsltExtention"
  xmlns:wdm="urn:schemas-themidnightcoders-com:xml-wdm"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:msdata="urn:schemas-microsoft-com:xml-msdata"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
  
  <xsl:template name="codegen.client.ui.testdrive">
    <xsl:variable name="class-name" select="codegen:getClassName(@name,@wdm:Schema)" />
    <xsl:variable name="id" select="@id"   />
    <xsl:variable name="pk" select="xs:key/@name" />
    <xsl:variable name="table" select="@name"   />
	<xsl:variable name="schema" select="@wdm:Schema"   />
    <file name="{$class-name}View.mxml" override="true" type="xml" addxmlversion="true">
      <mx:VBox xmlns:mx="http://www.adobe.com/2006/mxml" width="100%" height="100%" label="Products">
        <mx:Script>
          &lt;![CDATA[
            import mx.controls.Alert;
            import mx.events.CollectionEvent;
            import <xsl:value-of select="codegen:getClientNamespace(codegen:getCurrentSchema(), 0)" />.<xsl:value-of select="$class-name" />;
            import <xsl:value-of select="codegen:getClientNamespace(codegen:getCurrentSchema(), 0)" />.ActiveRecords;
        import mx.collections.ArrayCollection;

        [Bindable]
        private var _searchResult:ArrayCollection;

        private var _pageSize:int;

        [Bindable]
        public function set pageSize(value:int):void
        {
        _pageSize = value;

        _searchResult = ActiveRecords.<xsl:value-of select="$class-name" />.findAll({PageSize:_pageSize});
            }

            public function get pageSize():int
            {
              return _pageSize;
            }
            
            private function onAddClick():void
            {
            	<xsl:value-of select="$class-name"/>AddView.ShowDialog();
            }
          ]]&gt;
          </mx:Script>
        <mx:Button label="Add New" click="onAddClick()" />
        <mx:Label text="Table records:" />
          <![CDATA[
        <mx:DataGrid width="100%" height="100%" dataProvider="{_searchResult}" editable="true">
          ]]>
        <mx:columns>
          <mx:DataGridColumn width="70" editable="false" itemRenderer="UI.TestDrive.Renderers.SaveButtonItemRenderer"/>
          <mx:DataGridColumn width="80" editable="false" itemRenderer="UI.TestDrive.Renderers.RemoveButtonItemRenderer"/>
          <xsl:for-each select="xs:complexType/xs:attribute[not(concat('@',@name) = key('fk',$class-name)/@xpath or concat('@',@name) = key('fk',codegen:FirstLetterToLower($class-name))/@xpath) or @msdata:ReadOnly='true']">
            <mx:DataGridColumn headerText="{codegen:getProperty($table,$schema,@name)}" dataField="{codegen:getPropertyName($table,$schema,@name,1)}">
              <xsl:if test="../../xs:key/xs:field[@xpath = concat('@',current()/@name)] or @msdata:ReadOnly='true'">
                <xsl:attribute name="editable">false</xsl:attribute>
              </xsl:if>
            </mx:DataGridColumn>
          </xsl:for-each>
        </mx:columns>
        <![CDATA[
        </mx:DataGrid>
        <mx:Label text="Total records: {_searchResult.length}" />
          ]]>
      </mx:VBox>
    </file>

  </xsl:template>
  <xsl:template name="codegen.client.ui.testdrive.databaseview">    
    <file name="{codegen:getClassName(@name,@wdm:Schema)}DbView.mxml" override="true" type="xml" addxmlversion="true">
      <xsl:choose>
        <xsl:when test="codegen:CountSchemas(codegen:getCurrentDatabase()) = 1">
          &lt;mx:Canvas xmlns:mx="http://www.adobe.com/2006/mxml" width="726" height="650" xmlns:controls="UI.TestDrive.*" creationComplete="onCreationComplete()">
        </xsl:when>
        <xsl:otherwise>
          &lt;mx:Canvas xmlns:mx="http://www.adobe.com/2006/mxml" width="726" height="650" xmlns:controls="<xsl:value-of select="concat('UI.TestDrive.',codegen:getCurrentSchema(),'.*')"/>" creationComplete="onCreationComplete()">
        </xsl:otherwise>
      </xsl:choose>      
        &lt;mx:Script>
          &lt;![CDATA[
          [Bindable]
          private var currentRecordName:String = "";

          private function changeTable(index:int):void
          {
            vsActiveRecords.selectedIndex = index;
            currentRecordName = vsActiveRecords.selectedChild.label;
            Object(vsActiveRecords.selectedChild).pageSize = Number(cbPageSize.selectedItem);
          }

          private function onCreationComplete():void
          {
            cbPageSize.selectedItem = 40;
            changeTable(0);
          }
          ]]&gt;
        &lt;/mx:Script>
        &lt;mx:Binding source="cbPageSize.selectedItem" destination="Object(vsActiveRecords.selectedChild).pageSize" />
        &lt;mx:HBox width="100%" height="100%">
          &lt;mx:VBox height="100%" borderStyle="solid" paddingBottom="10"  paddingTop="10"
                   cornerRadius="10" backgroundColor="#769dbe" borderColor="#294074" >
            &lt;mx:Label text="Active Records" fontWeight="bold" />
            &lt;mx:Spacer />
            &lt;mx:Canvas bottom="10" top="10" width="250" height="100%"  horizontalScrollPolicy="off">
              &lt;mx:VBox  horizontalScrollPolicy="off" verticalScrollPolicy="off"  height="100%">
            <xsl:for-each select="xs:complexType/xs:choice/xs:element[@wdm:DatabaseObjectType='table']">
              <xsl:sort select="@name" />
              &lt;mx:LinkButton textAlign="left" width="100%" color="#ffffff" label="<xsl:value-of select="@name" />" click="{changeTable(<xsl:value-of select="position()-1"/>)}" /&gt;
            </xsl:for-each>
              &lt;/mx:VBox>
            &lt;/mx:Canvas>
          &lt;/mx:VBox>
          &lt;mx:VBox width="100%" height="100%" paddingBottom="10" paddingLeft="10" paddingRight="10" 
                   paddingTop="10" borderStyle="solid" cornerRadius="10" 
                   backgroundColor="#769dbe" borderColor="#294074">
            &lt;mx:HBox>
              &lt;mx:Label text="Active Record:"  fontWeight="bold" fontSize="17"/>
              <![CDATA[
              <mx:Label text="{currentRecordName}" fontWeight="bold" fontSize="17" />
              ]]>
            &lt;/mx:HBox>
            &lt;mx:HBox width="100%">
              &lt;mx:Spacer width="100%" />
              &lt;mx:VBox>
                &lt;mx:HBox>
                  &lt;mx:Label text="Page size:" />
                  &lt;mx:ComboBox id="cbPageSize">
                    &lt;mx:dataProvider>
                      &lt;mx:Array>
                        &lt;mx:Number>10&lt;/mx:Number>
                        &lt;mx:Number>20&lt;/mx:Number>
                        &lt;mx:Number>30&lt;/mx:Number>
                        &lt;mx:Number>40&lt;/mx:Number>
                        &lt;mx:Number>50&lt;/mx:Number>
                      &lt;/mx:Array>
                    &lt;/mx:dataProvider>
                  &lt;/mx:ComboBox>
                &lt;/mx:HBox>
              &lt;/mx:VBox>
            &lt;/mx:HBox>
  
            &lt;mx:ViewStack width="100%" height="100%" id="vsActiveRecords">
              <xsl:for-each select="xs:complexType/xs:choice/xs:element[@wdm:DatabaseObjectType='table']">
                <xsl:sort select="@name" />
                &lt;controls:<xsl:value-of select="codegen:getClassName(@name,@wdm:Schema)" />View label="<xsl:value-of select="codegen:getClassName(@name,@wdm:Schema)" />" /&gt;
              </xsl:for-each>
            &lt;/mx:ViewStack>
          &lt;/mx:VBox>
        &lt;/mx:HBox>
      &lt;/mx:Canvas>
    </file>
  </xsl:template>
  <xsl:template name="codegen.client.ui.app">
    <file name="testdrive.mxml" type="xml" addxmlversion="true">
    &lt;mx:Application xmlns:mx="http://www.adobe.com/2006/mxml" layout="absolute"
    <xsl:for-each select="/xs:schema/xs:element">
      <xsl:choose>
        <xsl:when test="codegen:CountSchemas(@name) = 1">
          xmlns:<xsl:value-of select="codegen:FirstLetterToUpper(@wdm:Schema)" />="UI.TestDrive.*"
        </xsl:when>
        <xsl:otherwise>
          xmlns:<xsl:value-of select="codegen:FirstLetterToUpper(@wdm:Schema)" />="UI.TestDrive.<xsl:value-of select="@wdm:Schema" />.*"
        </xsl:otherwise>
      </xsl:choose>      
    </xsl:for-each>
      >
      &lt;mx:TabNavigator width="100%" height="100%">
      <xsl:for-each select="/xs:schema/xs:element">
        <xsl:value-of select="codegen:setCurrentSchema(@wdm:Schema)" />
       &lt;<xsl:value-of select="codegen:FirstLetterToUpper(@wdm:Schema)" />:<xsl:value-of select="codegen:getClassName(@name,@wdm:Schema)" />DbView label="<xsl:value-of select="codegen:FirstLetterToUpper(@wdm:Schema)" />" width="100%" height="100%" top="20" bottom="20" left="20" right="20" /&gt;   
      </xsl:for-each>
      &lt;/mx:TabNavigator>
    &lt;/mx:Application>      
    </file>
  </xsl:template>
</xsl:stylesheet>