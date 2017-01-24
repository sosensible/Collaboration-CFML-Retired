<cfimport taglib="/share/tags/collaboration" prefix="co" />
<cfparam name="form" default="#structNew()#">
<cfswitch expression="#thisTag.executionMode#">
	<cfcase value="start">
		<cfparam name="attributes.id" default="">
		<cfparam name="attributes.name" default="">
		<cfparam name="attributes.class" default="">
		<cfparam name="attributes.action" default="">
		<cfparam name="attributes.method" default="post">
		<cfparam name="attributes.enctype" default="multipart/form-data">
		<cfparam name="attributes.validationMethod" default="">
		<cfparam name="attributes.mode" default="edit">
		<cfparam name="attributes.fieldBreak" default='<div style="clear:both;"></div>'>
		<cfparam name="attributes.delimiters" default=",">
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
		_coForm = structNew();
		_coForm.rootClassName = attributes.class;
		_coForm.classes = arrayNew(1);
		standardAttributes = 'id,action,processor,class,enctype,name,action,fieldBreak,delimiters,method,stateVariable,selfStyled,validationMethod,mode,_postGood';
		attributes = root.collaborate.mergeAttributes(attributes,root);
		attributeList = root.collaborate.createAttributeList(attributes,standardAttributes,root);
		if (attributes.name EQ '') {
			attributes.name = attributes.id;
		}
		if (attributes.class EQ '') {
			attributes.class = "_co_#attributes.name#";
		}
		/* setting all URL/FORM variables to _form scope internally */
		_form = {};
		if (structKeyExists(root,"attributes")
			AND structKeyExists(root.attributes,"_postBack")
		 	AND root.attributes._postBack EQ true) {
			if (structKeyExists(root.attributes,"_postForm") AND root.attributes._postForm EQ attributes.name) {
				_form = root.attributes;
			}
		} else if (structKeyExists(form,"_postBack") AND form._postBack EQ true) {
			if (structKeyExists(form,"_postForm") AND form._postForm EQ attributes.name) {
				_form = form;
			}
		} else if (structKeyExists(url,"_postBack") AND url._postBack) {
			if (structKeyExists(url,"_postForm") AND url._postForm EQ attributes.name) {
				_form = url;
			}
		}
		validationData = _form;

		/* MULTIMODE Form Features */
		multiMode = true;

		if(structKeyExists(ATTRIBUTES,"data")){
			returnData = createObject("component","#root.collaborate.get_shareClassPath()#objects.collaboration.returnData").init(attributes.data,attributes.delimiters);
			if(returnData.recordCount() && !structKeyExists(ATTRIBUTES,"mode")){
				ATTRIBUTES.mode = "edit";
			} else {
				ATTRIBUTES.mode = "add";
			}
		}

		if(structKeyExists(_form,"_postMode")){
			if(!structKeyExists(_form,"_postGood")){
				_form._postGood = false;
			}
			if(_form._postMode == "view"){
				//attributes.mode = "edit";
			} else if(ListFindNoCase(ATTRIBUTES.mode,_form._postMode) && _form._postGood == true){
				attributes.mode = "view";
			}
		}
		</cfscript>
		<!--- This needs to be refactored ABOVE the check for view, edit modification. --->
		<cfif attributes.validationMethod NEQ '' AND structKeyExists(_form,'_postBack') AND _postForm EQ attributes.name AND _form._postBack>
			<cfinvoke component="#root.collaborate#" method="#attributes.validationMethod#" argumentCollection='#validationData#' returnvariable="__validation">
		</cfif></cfcase>
	<cfcase value="end">
		<cfoutput>
		<form name="#attributes.name#" id="#attributes.id#" action="#attributes.action#" class="#attributes.class#<cfif len(attributes.mode)> #attributes.mode#__mode</cfif>" method="#attributes.method#" enctype="#attributes.encType#"#attributeList#>
#thisTag.generatedContent#
			<input type="hidden" name="_postBack" value="true">
			<input type="hidden" name="_postMode" value="#attributes.mode#">
			<input type="hidden" name="_postForm" value="#attributes.name#">
		</form><cfif structKeyExists(ATTRIBUTES,"labelwidth")>
		<cfparam name="ATTRIBUTES.labelAlign" default="right" />
		<cfparam name="ATTRIBUTES.labelpadright" default="6" />
		<co:css>
	###attributes.id# .coFieldLabel{
		width:#ATTRIBUTES.labelwidth#px;
		text-align:#ATTRIBUTES.labelAlign#;
		padding-right:#ATTRIBUTES.labelpadright#px;
		float:left;
	}
		</co:css></cfif></cfoutput>
		<cfset thisTag.GeneratedContent = ''>
	</cfcase>
</cfswitch>
<!---
<cfset elementName = "form"><cfinclude template="_base.cfm" />
--->