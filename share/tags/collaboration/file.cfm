<cfsetting enablecfoutputonly="true">
<cfswitch expression="#thisTag.executionMode#">
	<cfcase value="start">
		<cfparam name="attributes.id" default="">
		<cfparam name="attributes.name" default="">
		<cfparam name="attributes.value" default="">
		<cfparam name="attributes.label" default="">
		<cfparam name="attributes.labelClass" default="coFieldLabel">
		<cfparam name="attributes.editModes" default="add,edit">
		<cfparam name="attributes.viewModes" default="view,preview">
		<cfparam name="attributes.showModes" default="*">
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
		standardAttributes = 'id,name,value,fieldParam,label,labelClass,editModes,showModes,allowBreak,viewModes';
		attributes = root.collaborate.mergeAttributes(attributes,root);
		attributeList = root.collaborate.createAttributeList(attributes,standardAttributes,root);
		if (attributes.name EQ '') {
			attributes.name = attributes.id;
		}
		if (attributes.fieldParam) {
			attributes.value = root.collaborate.fieldParam(root._preDom.attributes,attributes.name,attributes.value);
		}
		/* MULTIMODE Form Features */
		editMode = true;
		showMode = true;
		fieldBreak = "";
		parentTags = getBaseTagList();
		firstForm = listFindNoCase(parentTags,"cf_form");
		if(firstForm){
			baseMeta = getBaseTagData("cf_form");
			if(structKeyExists(baseMeta.attributes,"mode")){
				editMode = false;
				showMode = false;
				formMode = baseMeta.attributes.mode;
				if(listFindNoCase(attributes.editModes,formMode)){
					editMode = true;
				}
				if(ATTRIBUTES.showModes == "*" || listFindNoCase(attributes.showModes,formMode)){
					showMode = true;
				}
			}
			/* Line Seperator */
			if(ATTRIBUTES.allowBreak && structKeyExists(baseMeta,"ATTRIBUTES.fieldBreak")){
				fieldBreak = baseMeta.attributes.fieldBreak;
			}
		}
		</cfscript>
	</cfcase>
	<cfcase value="end">
		<cfif attributes.value EQ ''>
			<cfset attributes.value = thisTag.generatedContent>
		</cfif>
		<cfscript>
		thisTag.generatedContent = '';
		editModeMarkup = '<input type="file" value="#attributes.value#" name="#attributes.name#" id="#attributes.id#"#attributeList# value="test">';
		previewHiddenModeMarkup = '';
		viewModeMarkup = '';
		</cfscript>
		<cfinclude template="#root.collaborate.get_sharePath()#tags/collaboration/tagRenderHandlers/formElement.cfm">
		<cfscript>
		writeOutput(formElement);
		</cfscript>
	</cfcase>
</cfswitch>
<cfsetting enablecfoutputonly="false">