<cfsetting enablecfoutputonly="true">
<cfswitch expression="#thisTag.executionMode#">
	<cfcase value="start">
		<cfparam name="attributes.id" default="">
		<cfparam name="attributes.name" default="">
		<cfparam name="attributes.value" default="">
		<cfparam name="attributes.caption" default="">
		<cfparam name="attributes.href" default="">
		<cfparam name="attributes.label" default="">
		<cfparam name="attributes.editModes" default="add,edit">
		<cfparam name="attributes.showModes" default="*">
		<cfparam name="attributes.viewModes" default="view,preview">
		<cfparam name="attributes.allowBreak" default="true">
		<cfparam name="attributes.fieldParam" default="true">
		<cfif StructKeyExists(caller,'root')>
			<cfset root = caller.root>
		<cfelse>
			<cfset root = caller>
		</cfif>
		<cfif NOT thisTag.hasEndTag>
			<cfthrow detail="End tag required" message="All Collaboration tags require an end tag." errorcode="collaboration.tag.attributes">
		</cfif>
		<cfif attributes.id EQ ''>
			<cfthrow detail="Missing required attribute: 'id'" message="'id' attribute is required">
		</cfif>
		<cfif NOT structKeyExists(root,"collaborate")>
			<cfthrow detail="Missing required collaborate object on calling page.">
		</cfif>
		<cfscript>
		standardAttributes = 'id,name,value,caption,href,fieldParam,label,viewModes,showModes,editModes,allowBreak';
		if (findNoCase("http",attributes.href)==1){
			if(structKeyExists(attributes,"onClick")){
				attributes.onClick = listAppend(attributes.onClick,"location.href='#attributes.href#';",";");
			} else {
				attributes.onClick = "location.href='#attributes.href#';";
			}
		}
		attributes = root.collaborate.mergeAttributes(attributes,root);
		attributeList = root.collaborate.createAttributeList(attributes,standardAttributes,root);
		if (attributes.name EQ '') {
			attributes.name = attributes.id;
		}
		if (attributes.fieldParam) {
			attributes.value = root.collaborate.fieldParam(root._preDom.attributes,attributes.name,attributes.value);
		}
		editMode = true;
		showMode = true;
		hidePreviewMode = false;
		fieldBreak = "";
		parentTags = getBaseTagList();
		firstForm = listFindNoCase(parentTags,"cf_form");
		if(firstForm){
			baseMeta = getBaseTagData("cf_form");
			if(structKeyExists(baseMeta.attributes,"mode")){
				editMode = false;
				showMode = false;
				hidePreviewMode = false;
				formMode = baseMeta.attributes.mode;
				if(listFindNoCase(attributes.editModes,formMode)){
					editMode = true;
				} else if (formMode == 'preview' && !listFindNoCase('preview',attributes.viewModes)) {
					hidePreviewMode = true;
				}
				if(ATTRIBUTES.showModes == "*" || listFindNoCase(attributes.showModes,formMode)){
					showMode = true;
				}
			}
			/* Line Seperator */
			if(ATTRIBUTES.allowBreak && structKeyExists(baseMeta,"ATTRIBUTES.fieldBreak")){
				fieldBreak &= baseMeta.attributes.fieldBreak;
			} else {
				fieldBreak &= "
";
			}
		}
		</cfscript>
	</cfcase>
	<cfcase value="end">
		<cfif attributes.caption EQ "" && thisTag.generatedContent NEQ "">
			<cfset attributes.caption = thisTag.generatedContent>
		<cfelseif attributes.caption EQ "">
			<cfset attributes.caption = attributes.value>
		</cfif>
		<cfif attributes.value EQ "" && thisTag.generatedContent NEQ "">
			<cfset attributes.value = thisTag.generatedContent>
		<cfelseif attributes.value EQ "">
			<cfset attributes.value = attributes.value>
		</cfif>
		<cfsavecontent variable="formElement"><cfoutput><button value="#attributes.value#" name="#attributes.name#" id="#attributes.id#"#attributeList#>#attributes.caption#</button></cfoutput></cfsavecontent>
		<cfscript>
		thisTag.generatedContent = '';
		editModeMarkup = '<button value="#attributes.value#" name="#attributes.name#" id="#attributes.id#"#attributeList#>#attributes.caption#</button>';
		previewHiddenModeMarkup = '<button value="#attributes.value#" name="#attributes.name#" id="#attributes.id#"#attributeList#>#attributes.caption#</button>';
		viewModeMarkup = '<button value="#attributes.value#" name="#attributes.name#" id="#attributes.id#"#attributeList#>#attributes.caption#</button>';
		</cfscript>
		<cfinclude template="#root.collaborate.get_sharePath()#tags/collaboration/tagRenderHandlers/formElement.cfm">
		<cfscript>
		writeOutput(formElement);
		</cfscript>
	</cfcase>
</cfswitch>
<cfsetting enablecfoutputonly="false">
<!---<cfset elementName = "button"><cfinclude template="_base.cfm" />--->