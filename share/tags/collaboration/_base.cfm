<cfsetting enablecfoutputonly="yes"><cfif !isDefined('elementName') OR !len(elementName)><cfthrow detail="colaboration tag failed to declare elementName." message="same" type="colaboration.code"></cfif><cfif thisTag.executionMode EQ "start"><cfscript>
	if(structKeyExists(CALLER,'root')){
		root = CALLER.root;
	} else {
		 root = {};
		 if(structKeyExists(CALLER.variables,'_preDOM')){ root['_preDOM'] = CALLER.variables._preDOM; } else { root['_preDOM'] = {}; }
	}
	</cfscript><cfoutput><#elementName# <cfloop collection="#attributes#" item="item"> #item#="#attributes[item]#"</cfloop><cfif thisTag.hasEndTag="true">><cfelse></#elementName#></cfif></cfoutput></cfif><cfif thisTag.executionMode EQ "end"><cfscript>
	value = thisTag.generatedContent;
	if(structKeyExists(root._preDOM,ATTRIBUTES.id)){
		if(structKeyExists(root._preDOM[ATTRIBUTES.id],'value')){
			value = root._preDOM[ATTRIBUTES.id].value;
		}
	}
	thisTag.generatedContent = "";
	</cfscript><cfoutput>#value#</#elementName#></cfoutput></cfif><cfsetting enablecfoutputonly="yes">