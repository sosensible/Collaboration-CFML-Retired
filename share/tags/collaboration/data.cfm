<cfsetting enablecfoutputonly="true">
<cfswitch expression="#thisTag.executionMode#">
	<cfcase value="start">
		<cfparam name="ATTRIBUTES.id" default="prototypeData">
		<cfparam name="ATTRIBUTES.value" default="">
		<cfparam name="ATTRIBUTES.template" default="">
		<cfparam name="ATTRIBUTES.stages" default="">
		<cfparam name="ATTRIBUTES.overwrite" default="true">
		<cfset doDataReturn = true>
		<cfif len(ATTRIBUTES.stages)>
			<cfif structKeyExists(caller._preDom,"__stage")>
				<cfif !listContains(ATTRIBUTES.stages,caller._preDom.__stage)>
					<!--- <cfexit method="exittag"> *** replaced due to peculiar effect on sibling tags *** --->
					<cfset doDataReturn = false>
				</cfif>
			<cfelse>
				<cfthrow detail="Run Stage Required" message="The run stage for Collaboration must be set for matching." errorcode="collaboration.tag.attributes">
			</cfif>
		</cfif>
		<cfif StructKeyExists(caller,'root')>
			<cfset root = caller.root>
		<cfelse>
			<cfset root = caller>
		</cfif>
		<cfif NOT thisTag.hasEndTag>
			<cfthrow detail="End tag required" message="All Collaboration tags require an end tag." errorcode="collaboration.tag.attributes">
		</cfif>

		<cfif ATTRIBUTES.id EQ ''>
			<cfthrow detail="Missing required attribute: 'id'" message="'id' attribute is required">
		</cfif>
		<cfif NOT structKeyExists(root,"collaborate")>
			<cfthrow detail="Missing required collaborate object on calling page.">
		</cfif>
		<cfscript>
		standardAttributes = 'id,value,template,stages';		
		attributes = root.collaborate.mergeAttributes(attributes,root);
		attributeList = root.collaborate.createAttributeList(attributes,standardAttributes,root);
		</cfscript>
	</cfcase>
	<cfcase value="end">
		<cfscript>
		if(doDataReturn){
			if(len(ATTRIBUTES.template)){
				ATTRIBUTES.VALUE = _includePrototype(template: ATTRIBUTES.template);
			} else if(ATTRIBUTES.value EQ ''){
				ATTRIBUTES.value = thisTag.generatedContent;
			}
			thisTag.generatedContent = '';
			try{
				structMerge(caller._preDom,deserializeJSON(ATTRIBUTES.value));//,ATTRIBUTES.overwrite
				caller._preDom.__prototypedata = true;
			} catch(any except) {
				caller._preDom.__prototypedata = false;
			}
		}
		</cfscript>
	</cfcase>
</cfswitch>
<cffunction name="_includePrototype" output="false" returnType="string">
	<cfargument name="template" type="string" required="true">
	<cfset var myReturn = "">
	<cfsaveContent variable="myReturn"><cfoutput><cfinclude template="#root.collaborate.get_actionPath()#_#template#_pd.cfm"></cfoutput></cfsaveContent>
	<cfreturn myReturn>
</cffunction>
<cffunction name="structMerge" output="false">
	<cfargument name="struct1" type="struct" required="true">
	<cfargument name="struct2" type="struct" required="true">
	<cfset var ii = "" />

	<!--- Loop over the second structure passed --->
	<cfloop collection="#arguments.struct2#" item="ii">
		<cfif structKeyExists(struct1,ii)>
		<!--- In case it already exists, we just update it --->
			<cfset struct1[ii] = listAppend(struct1[ii], struct2[ii])>
		<cfelse>
		<!--- In all the other cases, just create a new key with the values or list of values --->
			<cfset struct1[ii] = struct2[ii] />
		</cfif>
	</cfloop>
	<cfreturn struct1 />
</cffunction>
<cfscript>
function querymerge(querysource,queryoutput,keyColumn){
    var mergeColumn = querysource.columnlist;
    var valueArray = arrayNew(1);
    // define counters
    var i = 1;
    var iRow = 1;
    var jRow = 1;
    //if there is a 4th argument, use that as the mergeColumn
    if(arrayLen(arguments) GT 3) mergeColumn = arguments[4];    
    //loop through the merge column
    for(i=1; i lte listLen(mergeColumn,','); i=i+1) {
        if (listFindNoCase(queryoutput.columnlist,listGetAt(mergeColumn,i,','),',') eq 0) {
            // loop through each row of queryoutput and add information from querysource
            found = listGetAt(mergeColumn,i,',');
            for (iRow=1; iRow lte queryoutput.recordcount; iRow=iRow+1) {
                // find the row in querysource that matches the value in keycolumn from queryoutput  
                jRow = 1;
                while (jRow lt querysource.recordcount and querysource[keyColumn][jRow] neq queryoutput[keycolumn][iRow]) {
                    jRow = jRow + 1;
                }
                if (querysource[keyColumn][jRow] eq queryoutput[keycolumn][iRow]) {
                    valueArray[iRow] = querysource[listGetAt(mergeColumn,i,',')][jRow];
                }
            }
            // add the columnm
            queryaddcolumn(queryoutput,listGetAt(mergeColumn,i,','),valueArray);
        }
    }
    return queryoutput;
}
</cfscript>
<cfsetting enablecfoutputonly="false">