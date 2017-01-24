<cfparam name="attributes.labelClass" default="coopFieldLabel">
<cfparam name="editModeMarkup" default="">
<cfparam name="viewModeMarkup" default="">
<cfparam name="previewHiddenModeMarkup" default="">
<cfparam name="previewShownModeMarkup" default="">
<cfparam name="editMode" default="true">
<cfparam name="viewMode" default="false">
<cfparam name="hidePreviewMode" default="false">
<cfparam name="ShowPreviewMode" default="false">
<cfparam name="showMode" default="true">

<cfscript>
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
		} else if(listFindNoCase(attributes.viewModes,formMode)){
			viewMode = true;
			editMode = false;
			if (formMode == 'preview') {
				ShowPreviewMode = true;
			}
		}
		if(ATTRIBUTES.showModes == "*" || listFindNoCase(attributes.showModes,formMode)){
			showMode = true;
		}
		if (formMode == 'preview' && !listFindNoCase(attributes.viewModes,"preview")) {
			hidePreviewMode = true;
		}
	}
	/* Line Seperator */
	if(ATTRIBUTES.allowBreak && isDefined("baseMeta.ATTRIBUTES.fieldBreak")){
		fieldBreak = baseMeta.attributes.fieldBreak;
	}
}
formElement = "";
if(editMode){
	formElement = editModeMarkup;
} else if (hidePreviewMode) {
	formElement = previewHiddenModeMarkup;
} else if (viewMode) {
	formElement = viewModeMarkup;
	if (ShowPreviewMode) {
		formElement &= previewShownModeMarkup;
	}
}
if(len(attributes.label) && !hidePreviewMode){
	formElement = '<label for="#attributes.id#"><div class="#attributes.labelClass#">#attributes.label#</div>#formElement#</label>';
}
if(showMode){
	formElement = '			#formElement#';
	if (!hidePreviewMode) {
		formElement &=fieldBreak;
	}
} else {
	formElement = '';
}
THISTAG.generatedContent = '';
</cfscript>