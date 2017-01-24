<cfsetting enablecfoutputonly="true">
<cfswitch expression="#thisTag.executionMode#">
	<cfcase value="start">
		<cfparam name="attributes.id" default="">
		<cfparam name="attributes.name" default="">
		<cfparam name="attributes.value" default="">
		<cfparam name="attributes.cols" default="20">
		<cfparam name="attributes.rows" default="5">
		<cfparam name="attributes.label" default="">
		<cfparam name="attributes.labelClass" default="coFieldLabel">
		<cfparam name="attributes.fieldParam" default="true">
		<cfparam name="attributes.formatter" type="string" default="">
		<cfparam name="attributes.formatterMask" type="string" default="">
		<cfparam name="attributes.formatterType" type="string" default="">
		<cfparam name="attributes.formatterVersion" type="string" default="">
		<cfparam name="attributes.editModes" default="add,edit">
		<cfparam name="attributes.showModes" default="*">
		<cfparam name="attributes.viewModes" default="view,preview">
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
			standardAttributes = 'id,formatterVersion,formatterType,formatterMask,formatter,name,cols,rows,value,fieldParam,label,labelClass,editModes,showModes,allowBreak,viewModes';
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
			formModeClass = "";
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
				if(len(formMode)){
					formModeClass = "_#formMode#";
				}
			}
		</cfscript>
	</cfcase>
	<cfcase value="end">
		<cfscript>
		if(attributes.value EQ ''){
			attributes.value = thisTag.generatedContent;
			thisTag.generatedContent = '';
		}
		if(len(attributes.formatter)){
			attributes.value = root.collaborate._formatter(attributes.formatter,attributes.value,attributes);
		}
		editModeMarkup = '<textArea#attributeList# cols="#attributes.cols#" id="#attributes.id#" rows="#attributes.rows#" name="#attributes.name#">#attributes.value#</textArea>';
		viewModeMarkup = '<span#attributeList# id="#ATTRIBUTES.id#">#attributes.value#</span>';
		previewHiddenModeMarkup = '<input#attributeList# type="hidden" value="#attributes.value#" name="#attributes.name#" id="#attributes.id#"#attributeList# />';
		previewShownModeMarkup = '<input type="hidden" value="#attributes.value#" name="#attributes.name#" id="#attributes.id#_hidden"#attributeList# />';

		</cfscript>
		<cfinclude template="#root.collaborate.get_sharePath()#tags/collaboration/tagRenderHandlers/formElement.cfm">
		<cfscript>
		writeOutput(formElement);
		</cfscript>
	</cfcase>
</cfswitch>
<cfsetting enablecfoutputonly="false">
<!---
<cfset elementName = "textarea"><cfinclude template="_base.cfm" />
--->