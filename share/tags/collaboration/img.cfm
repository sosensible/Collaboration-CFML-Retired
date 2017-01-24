<cfsetting enablecfoutputonly="true">
<cfswitch expression="#thisTag.executionMode#">
	<cfcase value="start">
		<cfparam name="attributes.id" default="">
		<cfparam name="attributes.value" default="">
		<cfparam name="attributes.src" default="">
		<cfparam name="attributes.srcpath" default="">
		<cfparam name="attributes.alt" default="">
		<cfparam name="attributes.link" default="">
		<cfparam name="attributes.label" default="">
		<cfparam name="attributes.labelClass" default="coFieldLabel">
		<cfparam name="attributes.linkTarget" default="">
		<cfparam name="attributes.border" default="0">
		<cfparam name="attributes.editModes" default="add,edit">
		<cfparam name="attributes.showModes" default="*">
		<cfparam name="attributes.allowBreak" default="true">
		<cfparam name="attributes.cdnPrefix" default="">
		<cfif StructKeyExists(caller,'root')>
			<cfset root = caller.root>
		<cfelse>
			<cfset root = caller>
		</cfif>
		<cfif attributes.id EQ ''>
			<cfthrow detail="Missing required attribute: 'id'" message="'id' attribute is required">
		</cfif>
		<cfif NOT thisTag.hasEndTag>
			<cfthrow detail="End tag required" message="All Collaboration tags require an end tag." errorcode="collaboration.tag.attributes">
		</cfif>
		<cfif NOT structKeyExists(root,"collaborate")>
			<cfthrow detail="Missing required collaborate object on calling page.">
		</cfif>
		<cfscript>
		standardAttributes = 'id,alt,label,labelClass,src,srcpath,link,linkTarget,value,border,editModes,showModes,allowBreak';
		attributes = root.collaborate.mergeAttributes(attributes,root);
		attributeList = root.collaborate.createAttributeList(attributes,standardAttributes,root);
		/* This function alias  */
		attributes.src = root.collaborate.parse_mediaAlias(root._api,attributes.src);
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
		if(structKeyExists(ATTRIBUTES,"width") && !len(trim(ATTRIBUTES.width))){structDelete(ATTRIBUTES,"width");}
		if(structKeyExists(ATTRIBUTES,"height") && !len(trim(ATTRIBUTES.height))){structDelete(ATTRIBUTES,"height");}
		</cfscript>
	</cfcase>
	<cfcase value="end">
		<cfscript>
		formElement = "";
		if(len(attributes.value)){
			attributes.src = attributes.value;
		}
		if(len(attributes.label)){
			formElement &= '<div class="#attributes.labelClass#">#attributes.label#</div>';
		}
		formElement &= '<img id="#attributes.id#" alt="#attributes.alt#" src="#attributes.cdnPrefix##attributes.srcpath##attributes.src#" border="#attributes.border#"#attributeList#/>';
		if(len(attributes.link)){
			formElement = '<a href="#attributes.link#" target="#attributes.linkTarget#">#formElement#</a>';
		}
		if(showMode){
			writeOutput("			#formElement##fieldBreak#");
		}
		</cfscript>
		<!---
		<cfsavecontent variable="formElement">
			<cfoutput><cfif attributes.label NEQ ''><div class="#attributes.labelClass#">#attributes.label#</div></cfif><img id="#attributes.id#" alt="#attributes.alt#" src="#attributes.src#" border="#attributes.border#"#attributeList#/></cfoutput>
		</cfsavecontent>
		<cfif attributes.link NEQ ''>
			<cfset formElement = '<a href="#attributes.link#" target="#attributes.linkTarget#">#formElement#</a>'>
		</cfif>
		<cfif showMode><cfoutput>#formElement##fieldBreak#</cfoutput></cfif>
		--->
	</cfcase>
</cfswitch>
<cfsetting enablecfoutputonly="false">
<!---
<cfset elementName = "img"><cfinclude template="_base.cfm" />
--->