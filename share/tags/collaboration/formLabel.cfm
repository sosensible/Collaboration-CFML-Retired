<cfsetting enablecfoutputonly="true">
<cfswitch expression="#thisTag.executionMode#">
	<cfcase value="start">
		<cfparam name="attributes.id" default="">
		<cfparam name="attributes.for" default="">
		<cfparam name="attributes.label" default="">
		<cfparam name="attributes.labelClass" default="coFieldLabel">
		<cfparam name="attributes.wrapElement" default="span">
		<cfparam name="attributes.editModes" default="add,edit">
		<cfparam name="attributes.showModes" default="*">
		<cfparam name="attributes.allowBreak" default="true">
		<cfparam name="attributes.skip" default="false">
		<cfparam name="attributes.value" default="">
		<cfif ATTRIBUTES.skip><cfExit method="exittag"></cfif>
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
		standardAttributes = 'id,for,label,labelClass,wrapElement,editModes,showModes,allowBreak';
		attributes = root.collaborate.mergeAttributes(attributes,root);
		attributeList = root.collaborate.createAttributeList(attributes,standardAttributes,root);
		</cfscript>
	</cfcase>
	<cfcase value="end">
		<cfscript>
		if (attributes.value EQ '' AND thisTag.generatedContent NEQ '')
		{
			attributes.value = thisTag.generatedContent;
		}
		/* MULTIMODE Form Features */
		editMode = true;
		showMode = true;
		fieldBreak = "";
		parentTags = getBaseTagList();
		firstForm = listFindNoCase(parentTags,"cf_form");
		if(firstForm){
			editMode = false;
			showMode = false;
			baseMeta = getBaseTagData("cf_form");
			if(structKeyExists(baseMeta.attributes,"mode")){
				formMode = baseMeta.attributes.mode;
				if(listFindNoCase(attributes.editModes,formMode)){
					editMode = true;
				}
				if(ATTRIBUTES.showModes == "*"){
					showMode = true;
				} else if(listFindNoCase(attributes.showModes,formMode)){
					showMode = true;
				}
			}
			/* Line Seperator */
			if(ATTRIBUTES.allowBreak && structKeyExists(baseMeta,"ATTRIBUTES.fieldBreak")){
				fieldBreak = baseMeta.attributes.fieldBreak;
			}
		}
		</cfscript>
		<cfif attributes.value EQ '' AND thisTag.GeneratedContent EQ ''>
			<cfset attributes.value = "&nbsp;">
		<cfelse>
			<cfif thisTag.generatedContent NEQ ''>
				<cfset ATTRIBUTES.value = thisTag.generatedContent>
			</cfif>
		</cfif>
		<cfset thisTag.generatedContent = ''>
		<cfset formElement = '<label for="#attributes.for#"><div class="#attributes.labelClass#">#attributes.label#</div>#attributes.value#</label>'>
		<cfif showMode><cfoutput>#formElement##fieldBreak#</cfoutput></cfif>
	</cfcase>
</cfswitch>
<cfsetting enablecfoutputonly="false">