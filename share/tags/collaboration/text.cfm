<cfsetting enablecfoutputonly="true">
<cfswitch expression="#thisTag.executionMode#">
	<cfcase value="start">
		<cfparam name="attributes.id" default="">
		<cfparam name="attributes.value" default="">
		<cfparam name="attributes.append" default="">
		<cfparam name="attributes.prepend" default="">
		<cfparam name="attributes.label" default="">
		<cfparam name="attributes.labelClass" default="coFieldLabel">
		<cfparam name="attributes.wrapElement" default="span">
		<cfparam name="attributes.nonBreaking" default="false">
		<cfparam name="attributes.formatter" type="string" default="">
		<cfparam name="attributes.formatterMask" type="string" default="">
		<cfparam name="attributes.formatterType" type="string" default="">
		<cfparam name="attributes.formatterVersion" type="string" default="">
		<cfparam name="attributes.editModes" default="add,edit">
		<cfparam name="attributes.showModes" default="*">
		<cfparam name="attributes.allowBreak" default="true">
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
		standardAttributes = 'id,formatter,formatterVersion,formatterType,formatterMask,value,label,labelClass,nonBreaking,wrapElement,editModes,showModes,allowBreak,append,prepend';
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
		if (len(ATTRIBUTES.append)){
			ATTRIBUTES.value &= ATTRIBUTES.append;
		}
		if (len(ATTRIBUTES.prepend)){
			ATTRIBUTES.value = ATTRIBUTES.prepend & ATTRIBUTES.value;
		}
		if (attributes.nonBreaking) {
			attributes.value = reReplace(attributes.value,'\s','&nbsp;','all');
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
		</cfif>
		<cfif len(attributes.formatter)>
			<cfset attributes.value = root.collaborate._formatter(attributes.formatter,attributes.value,attributes)>
		</cfif>
		<cfset thisTag.generatedContent = ''>
		<cfsavecontent variable="formElement"><cfoutput><#attributes.wrapElement# id="#attributes.id#"#attributeList#>#attributes.value#</#attributes.wrapElement#></cfoutput></cfsavecontent>
		<cfif attributes.label NEQ ''><cfset formElement = '<label for="#attributes.id#"><div class="#attributes.labelClass#">#attributes.label#</div>#formElement#</label>'></cfif>
		<cfif showMode><cfoutput>#formElement##fieldBreak#</cfoutput></cfif>
	</cfcase>
</cfswitch>
<cfsetting enablecfoutputonly="false">