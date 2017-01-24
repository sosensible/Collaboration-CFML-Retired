<cfsetting enablecfoutputonly="true">
<cfswitch expression="#thisTag.executionMode#">
	<cfcase value="start">
		<cfparam name="attributes.id" default="">
		<cfparam name="attributes.name" default="">
		<cfparam name="attributes.value" default="">
		<cfparam name="attributes.label" default="">
		<cfparam name="attributes.labelClass" default="coFieldLabel">
		<cfparam name="attributes.editModes" default="add,edit">
		<cfparam name="attributes.showModes" default="*">
		<cfparam name="attributes.viewModes" default="view,preview">
		<cfparam name="attributes.allowBreak" default="true">
		<cfparam name="attributes.useLabel" default="FALSE">
		<cfif StructKeyExists(caller,'root')>
			<cfset root = caller.root>
		<cfelse>
			<cfset root = caller>
		</cfif>
		<cfif NOT thisTag.hasEndTag>
			<cfthrow detail="End tag required" message="All Collaboration tags require an end tag." errorcode="collaboration.tag.attributes">
		</cfif>
		<cfif NOT structKeyExists(root,"collaborate")>
			<cfthrow detail="Missing required collaborate object on calling page.">
		</cfif>
		<cfif attributes.id EQ ''>
			<cfthrow detail="Missing required attribute: 'id'" message="'id' attribute is required">
		</cfif>
		<cfscript>
		standardAttributes = "id,name,value,fieldParam,label,allowBreak,useLabel,editModes,showModes,labelclass,viewModes,src";
		attributes = root.collaborate.mergeAttributes(attributes,root);
		attributeList = root.collaborate.createAttributeList(attributes,standardAttributes,root);
		if (attributes.name EQ '') {
			attributes.name = attributes.id;
		}
		</cfscript>
	</cfcase>
	<cfcase value="end">
		<cfif attributes.value EQ ''>
			<cfif attributes.value EQ '' and thisTag.generatedContent EQ ''>
				<cfset attributes.value = 'Submit'>
			<cfelseif attributes.value EQ ''>
				<cfset attributes.value = thisTag.generatedContent>
			</cfif>
		</cfif>	
		<cfscript>
		 if(ATTRIBUTES.useLabel){
			attributes.label = "&nbsp;";
		}
		editModeMarkup = '<input type="submit" value="#attributes.value#" name="#attributes.name#" id="#attributes.id#"#attributeList# />';
		viewModeMarkup = editModeMarkup;
		previewHiddenModeMarkup = editModeMarkup;
		THISTAG.generatedContent = '';
		</cfscript>
		<cfinclude template="#root.collaborate.get_sharePath()#tags/collaboration/tagRenderHandlers/formElement.cfm">
		<cfscript>
		if(showMode){writeOutput(formElement);}
		</cfscript>
	</cfcase>
</cfswitch>
<cfsetting enablecfoutputonly="false">