<cfsetting enablecfoutputonly="true">
<cfswitch expression="#thisTag.executionMode#">
      <cfcase value="start">
            <cfparam name="attributes.id" default="">
            <cfparam name="attributes.allowBreak" default="true">
            <cfparam name="attributes.editModes" default="add,edit">
            <cfparam name="attributes.display" default="">
            <cfparam name="attributes.fieldParam" default="true">
            <cfparam name="attributes.label" default="">
            <cfparam name="attributes.labelClass" default="coFieldLabel">
            <cfparam name="attributes.name" default="">
            <cfparam name="attributes.selected" default="">
            <cfparam name="attributes.showModes" default="*">
            <cfparam name="attributes.value" default="">
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
            standardAttributes = 'id,name,label,value,label,display,labelClass,fieldParam,selected,selectedValue,showModes,editModes,allowBreak';
            attributes = root.collaborate.mergeAttributes(attributes,root);
            attributeList = root.collaborate.createAttributeList(attributes,standardAttributes,root);
            if(len(attributes.selected)){
                  if(attributes.value == attributes.selectedValue){
                        attributes.selected = attributes.value;
                  }
            }
			selected = ' selected="#attributes.selected#"';
            if (attributes.name EQ '') {
                  attributes.name = attributes.id;
            }
            if (attributes.fieldParam) {
                  attributes.value = root.collaborate.fieldParam(root._preDom.attributes,attributes.name,attributes.value);
            }
            if(ATTRIBUTES.selected == ATTRIBUTES.value){
                  isChecked = 'checked="checked" ';
            } else {
                  isChecked = '';
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
					fieldBreak &= baseMeta.attributes.fieldBreak;
				} else {
					fieldBreak &= "
";
				}
			}
            </cfscript>
      </cfcase>
      <cfcase value="end">
			<cfscript>
			/*
			if(len(attributes.value)){
				attributes.value = thisTag.generatedContent;
			}
			writeDump(ATTRIBUTES);writeDump(caller._preDom[ATTRIBUTES.id]);abort;
			*/
			formElement = '			<input #isChecked#type="checkBox" value="#attributes.value#" name="#attributes.name#" id="#attributes.id#"#attributeList#><label for="#attributes.id#" class="#attributes.labelClass#">';

			if(len(attributes.label)){
				formElement = '<label for="#attributes.id#"><div class="#attributes.labelClass#">#attributes.label#</div>#formElement#</label>';
			}
			formElement &= '</label>';
			if(!editMode){
				formElement = "asdf" & iif(len(attributes.display),'attributes.display',"'&nbsp;'");
			}
			if(showMode){
				formElement = '			#formElement##fieldBreak#';
			}
			editModeMarkup = '<input #isChecked#type="checkBox" value="#attributes.value#" name="#attributes.name#" id="#attributes.id#"#attributeList#>';
			previewHiddenModeMarkup = '<input type="hidden" value="#attributes.value#" name="#attributes.name#" id="#attributes.id#"#attributeList# />';
			viewModeMarkup = '<span#attributeList# id="#ATTRIBUTES.id#"#attributeList#>#attributes.value#</span>';
			</cfscript>
			<cfinclude template="#root.collaborate.get_sharePath()#tags/collaboration/tagRenderHandlers/formElement.cfm">
			<cfscript>
			writeOutput(formElement);
			</cfscript>
      </cfcase>
</cfswitch>
<cfsetting enablecfoutputonly="false">