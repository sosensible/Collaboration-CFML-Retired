<cfsetting enablecfoutputonly="true">
<cfswitch expression="#thisTag.executionMode#">
	<cfcase value="start">
		<cfparam name="attributes.id" default="">
		<cfparam name="attributes.allowBreak" default="true">
		<cfparam name="attributes.data" default="">
		<cfparam name="attributes.delimiters" default=",">
		<cfparam name="attributes.displayField" default="display">
		<cfparam name="attributes.editModes" default="add,edit">
		<cfparam name="attributes.viewModes" default="view,preview">
		<cfparam name="attributes.fieldParam" default="true">
		<cfparam name="attributes.formatter" type="string" default="">
		<cfparam name="attributes.formatterMask" type="string" default="">
		<cfparam name="attributes.formatterType" type="string" default="">
		<cfparam name="attributes.formatterVersion" type="string" default="">
		<cfparam name="attributes.innerAttributes" default="#structNew()#">
		<cfparam name="attributes.label" default="">
		<cfparam name="attributes.labelClass" default="coFieldLabel">
		<cfparam name="attributes.name" default="">
		<cfparam name="attributes.selected" default="">
		<cfparam name="attributes.showModes" default="*">
		<cfparam name="attributes.valueField" default="value">
		<cfif StructKeyExists(caller,'root')>
			<cfset root = caller.root>
		<cfelse>
			<cfset root = caller>
		</cfif>
		<cfif NOT thisTag.hasEndTag>
			<cfthrow detail="End tag required" message="All collaboration tags require an end tag." errorcode="collaboration.tag.attributes">
		</cfif>
		<cfif NOT structKeyExists(root,"collaborate")>
			<cfthrow detail="Missing required Collaboration object on calling page.">
		</cfif>
		<cfif attributes.id EQ ''>
			<cfthrow detail="Missing required attribute: 'id'" message="'id' attribute is required">
		</cfif>
		<cfscript>
		standardAttributes = 'id,name,data,innerAttributes,valueField,displayField,label,labelClass,delimiters,fieldParam,selected,editModes,showModes,allowBreak,formatterMask,formatter,formatterVersion,formatterType,viewModes';
		ignoredInnerAttributes = 'id';
		attributes = root.collaborate.mergeAttributes(attributes,root);
		attributeList = root.collaborate.createAttributeList(attributes,standardAttributes,root);
		if (attributes.name EQ '') {
			attributes.name = attributes.id;
		}
		if (attributes.fieldParam) {
			attributes.selected = root.collaborate.fieldParam(root._preDom.attributes,attributes.name,attributes.selected);
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
		thisTag.innerAttributes = arrayNew(1);
		thisTag.innerDataAttributes = structNew();
		innerDataAttributeList = '';
		innerAttributeList = '';
		</cfscript>
	</cfcase>
	<cfcase value="end">
		<cfscript>
		if (listLen(structKeyList(attributes.innerAttributes))) {
			if (NOT arrayLen(thisTag.innerAttributes)) {
				thisTag.innerAttributes[1] = structNew();
			}
			structAppend(thisTag.innerAttributes[1],attributes.innerAttributes);
		}
		if (arrayLen(thisTag.innerAttributes)) {
			for (iAttrib in thisTag.innerAttributes[1]) {
				if (left(iAttrib,5) EQ 'data_') {
					thisTag.innerDataAttributes[iAttrib] = thisTag.innerAttributes[1][iAttrib];
					structDelete(thisTag.innerAttributes[1],iAttrib);
				}
			}
		}
		if (arrayLen(thisTag.innerAttributes)) {
			innerAttributeList = root.collaborate.createAttributeList(thisTag.innerAttributes[1],ignoredInnerAttributes,root);
		}
		checkedList = attributes.selected;
		checkedDisplayList = "";
		formElement = "";
		if (isSimpleValue(attributes.data) AND attributes.data EQ ''){
			attributes.data = thisTag.generatedContent;
			thisTag.generatedContent = '';
		}

		formElement = formElement & '
			<select name="#attributes.name#" id="#attributes.id#"#attributeList#>';
		formSelection = "";

		// *** START DATA LOOP (preData,data,postData) *** //
		for(iSet=1;iSet<=3;iSet++){
			thisSet = listGetAt("preData,data,postData",iSet);
			if(structKeyExists(ATTRIBUTES,thisSet)){
				dataSet = ATTRIBUTES[thisSet];
				returnData = createObject("component","#root.collaborate.get_shareClassPath()#objects.collaboration.returnData").init(appData:dataSet,delimiters:attributes.delimiters,classPath:#root.collaborate.get_shareClassPath()#);
				recordCount = returnData.recordCount();
				for(iRow=1; iRow LTE recordCount; iRow = iRow + 1) {
					data = returnData.returnDataRowStruct(iRow);
					if (attributes.valueField EQ '')  {
						value = data[1];
					} else {
						if (reFindNoCase("##*##",attributes.valueField)) {
							value = evaluate(attributes.valueField);
						} else {
							value = data[attributes.valueField];
						}
					}
					if (attributes.displayField EQ '')  {
						display = data[1];
					} else {
						if (reFindNoCase("##*##",attributes.displayField)) {
							display = evaluate(attributes.displayField);
						} else {
							display = data[attributes.displayField];
						}
					}
					if (len(attributes.formatter)) {
						display = root.collaborate._formatter(attributes.formatter,display,attributes);
					}
					innerDataAttributeList = '';
					for (iAttrib in thisTag.innerDataAttributes) {
						if (reFindNoCase("##*##",thisTag.innerDataAttributes[iAttrib])) {
							innerDataAttributeList = listAppend(innerDataAttributeList,'#right(iAttrib,len(iAttrib)-5)#="#evaluate(thisTag.innerDataAttributes[iAttrib])#"'," ");
						} else {
							innerDataAttributeList = listAppend(innerDataAttributeList,'#right(iAttrib,len(iAttrib)-5)#="#data[thisTag.innerDataAttributes[iAttrib]]#"'," ");
						}
					}
					if (innerDataAttributeList NEQ ''){
						innerDataAttributeList = ' ' & innerDataAttributeList;
					}
					if (listFind(checkedList,value)) {
						checkedDisplayList = listAppend(checkedDisplayList,display);
						ischecked = ' selected="selected" ';
						formSelection = listAppend(formSelection,display);
					} else {
						ischecked = '';
					}
					formElement = formElement & '
				<option value="#value#"#isChecked##innerAttributeList##innerDataAttributeList#>#display#</option>';
				}
			}
		}
		// *** END DATA LOOP (preData,data,postData) *** //

		formElement = formElement & '
			</select>';
		editModeMarkup = formElement;
		previewHiddenModeMarkup = '<input type="hidden" value="#checkedList#" name="#attributes.name#" id="#attributes.id#"#attributeList# />';
		previewShownModeMarkup = '<input type="hidden" value="#checkedList#" name="#attributes.name#" id="#attributes.id#_hidden"#attributeList# />';
		viewModeMarkup = '<span#attributeList# id="#ATTRIBUTES.id#">#checkedDisplayList#</span>';
		</cfscript>
		<cfinclude template="#root.collaborate.get_sharePath()#tags/collaboration/tagRenderHandlers/formElement.cfm">
		<cfoutput>
		#formElement#
 		</cfoutput>
 		
	</cfcase>
</cfswitch>
<cfsetting enablecfoutputonly="false">