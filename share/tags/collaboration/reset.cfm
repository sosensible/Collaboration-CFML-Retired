<cfsetting enablecfoutputonly="true">
<cfswitch expression="#thisTag.executionMode#">
	<cfcase value="start">
		<cfparam name="attributes.id" default="">
		<cfparam name="attributes.name" default="">
		<cfparam name="attributes.value" default="">
		<cfparam name="attributes.label" default="">
		<cfparam name="attributes.labelClass" default="coFieldLabel">
		<cfparam name="attributes.editModes" default="add,edit">
		<cfparam name="attributes.viewModes" default="edit">
		<cfparam name="attributes.showModes" default="*">
		<cfparam name="attributes.allowBreak" default="true">
		<cfparam name="attributes.useLabel" default="false">
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
		<cfscript>
		standardAttributes = "id,name,value,fieldParam,label,allowBreak,useLabel,editModes,showModes,labelclass,viewModes";
		attributes = root.collaborate.mergeAttributes(attributes,root);
		attributeList = root.collaborate.createAttributeList(attributes,standardAttributes,root);
		if (attributes.name EQ '') {
			attributes.name = attributes.id;
		}
		if(!len(attributes.name) && !len(attributes.id)){
			structDelete(attributes,"name");
			structDelete(attributes,"id");
		}
		/* MULTIMODE Form Features */

		</cfscript>
	</cfcase>
	<cfcase value="end">
		<cfif attributes.value EQ ''>
			<cfif attributes.value EQ '' and thisTag.generatedContent EQ ''>
				<cfset attributes.value = 'Reset'>
			<cfelseif attributes.value EQ ''>
				<cfset attributes.value = thisTag.generatedContent>
			</cfif>
		</cfif>	
		<cfscript>
		if(ATTRIBUTES.useLabel){
			attributes.label = "&nbsp;";
		}
		</cfscript>
		<cfoutput>
		<cfoutput><cfsavecontent variable="editModeMarkup"><input type="reset" value="#attributes.value#"<cfif structKeyExists(attributes,"name")> name="#attributes.name#"</cfif><cfif structKeyExists(attributes,"id")> id="#attributes.id#"</cfif>#attributeList# /></cfsavecontent></cfoutput>
		<cfset previewHiddenModeMarkup = ''>
		<cfset viewModeMarkup = ''>
		<cfinclude template="#root.collaborate.get_sharePath()#tags/collaboration/tagRenderHandlers/formElement.cfm">
		#formElement#
		</cfoutput>
	</cfcase>
</cfswitch>
<cfsetting enablecfoutputonly="false">