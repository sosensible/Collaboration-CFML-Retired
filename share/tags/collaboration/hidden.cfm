<cfsetting enablecfoutputonly="true">
<cfswitch expression="#thisTag.executionMode#">
	<cfcase value="start">
		<cfparam name="attributes.id" default="">
		<cfparam name="attributes.name" default="">
		<cfparam name="attributes.value" default="">
		<cfparam name="attributes.fieldParam" default="true">
		<cfparam name="attributes.label" default="">
		<cfparam name="attributes.allowBreak" default="true">
		<cfparam name="attributes.editModes" default="add,edit">
		<cfparam name="attributes.viewModes" default="view,preview">
		<cfparam name="attributes.showModes" default="*">
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
		standardAttributes = 'id,name,value,fieldParam,formatter,formatterVersion,formatterType,formatterMask,label,editModes,viewModes,showModes,allowBreak';
		attributes = root.collaborate.mergeAttributes(attributes,root);
		attributeList = root.collaborate.createAttributeList(attributes,standardAttributes,root);
		if (attributes.name EQ '') {
			attributes.name = attributes.id;
		}
		if (attributes.fieldParam) {
			attributes.value = root.collaborate.fieldParam(root._preDom.attributes,attributes.name,attributes.value);
		}
		</cfscript>
	</cfcase>
	<cfcase value="end">
		<cfif attributes.value EQ ''>
			<cfset attributes.value = thisTag.generatedContent>
		</cfif>
		<cfscript>
		thisTag.generatedContent = '';
		editModeMarkup = '<input type="hidden" value="#attributes.value#" name="#attributes.name#" id="#attributes.id#"#attributeList#>';
		previewHiddenModeMarkup = editModeMarkup;
		previewShownModeMarkup = editModeMarkup;
		viewModeMarkup = editModeMarkup;
		</cfscript>
		<cfinclude template="#root.collaborate.get_sharePath()#tags/collaboration/tagRenderHandlers/formElement.cfm">
		<cfscript>
		writeOutput(formElement);
		</cfscript>
	</cfcase>
</cfswitch>
<cfsetting enablecfoutputonly="false">