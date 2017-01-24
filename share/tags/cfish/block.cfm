<cfif thisTag.executionMode EQ "start"><cfsetting enablecfoutputonly="true">
	<cfparam name="ATTRIBUTES.name" default="">
	<cfif NOT isSimpleValue(attributes.name) OR attributes.name EQ "">
		<cfthrow type="cfish.tag" message="missing name attribute" detail="The CFish block tag requires a name attribute." />
	</cfif>
	<cfparam name="ATTRIBUTES.handler" default="#ATTRIBUTES.name#">
	<cfparam name="ATTRIBUTES.active" default="true">
	<cfparam name="ATTRIBUTES.mode" default="-"> <!--- [set](replace),append,param,prepend,render --->
	<cfscript>
	content = REQUEST._content;
	ATTRIBUTES._mode = ATTRIBUTES.mode;
	if(ATTRIBUTES.mode EQ "-"){
		if(listContains(getBaseTagList(),"CF_SKIN")){
			ATTRIBUTES.mode = "render";
		} else {
			ATTRIBUTES.mode = "set";
		}
	}
	</cfscript>
	<!---
	<cfif NOT base.attributes.cfish.isBlockActive(block:ATTRIBUTES.name)>
		<cfexit method="exitTag">
	</cfif>
	--->
</cfif>

<cfif thisTag.executionMode EQ "end">
	<cfswitch expression="#ATTRIBUTES.mode#">
		<cfcase value="set,-">
			<cfscript>
			content.setBlockContent(name:ATTRIBUTES.name,value:THISTAG.generatedContent,attributes:ATTRIBUTES);
			</cfscript>
		</cfcase>
		<cfcase value="append">
			<cfscript>
			content.appendBlockContent(name:ATTRIBUTES.name,value:THISTAG.generatedContent,attributes:ATTRIBUTES);
			</cfscript>
		</cfcase>
		<cfcase value="param">
			<cfscript>
			content.paramBlockContent(name:ATTRIBUTES.name,value:THISTAG.generatedContent,attributes:ATTRIBUTES);
			</cfscript>
		</cfcase>
		<cfcase value="prepend">
			<cfscript>
			content.prependBlockContent(name:ATTRIBUTES.name,value:THISTAG.generatedContent,attributes:ATTRIBUTES);
			</cfscript>
		</cfcase>
		<cfcase value="paramRender">
			<cfscript>
			content.paramBlockContent(name:ATTRIBUTES.name,value:THISTAG.generatedContent,attributes:ATTRIBUTES);
			</cfscript>
			<cfif fileExists("/share/tags/cfish/handlers/#ATTRIBUTES.name#.cfm")>
				<cfscript>
				VARIABLES.attr = duplicate(ATTRIBUTES);
				structAppend(VARIABLES.attr,content.getBlockContentAttributes(),FALSE);
				</cfscript>
				<cfoutput><cfinclude template="/share/tags/cfish/renderers/#ATTRIBUTES.name#.cfm"></cfoutput>
			<cfelse>
				<cfoutput>#content.getBlockContent(ATTRIBUTES.name)#</cfoutput>
			</cfif>
		</cfcase>
		<cfcase value="setRender">
			<cfscript>
			thisTag.generatedContent=""
			content.setBlockContent(name:ATTRIBUTES.name,value:THISTAG.generatedContent,attributes:ATTRIBUTES);
			thisTag.generatedContent="";
			</cfscript>
			<cfif fileExists("/share/tags/cfish/handlers/#ATTRIBUTES.name#.cfm")>
				<cfscript>
				VARIABLES.attr = duplicate(ATTRIBUTES);
				structAppend(VARIABLES.attr,content.getBlockContentAttributes(),FALSE);
				</cfscript>
				<cfoutput><cfinclude template="/share/tags/cfish/renderers/#ATTRIBUTES.name#.cfm"></cfoutput>
			<cfelse>
				<cfoutput>#content.getBlockContent(ATTRIBUTES.name)#</cfoutput>
			</cfif>
		</cfcase>
		<cfcase value="render">
			<cfif fileExists("/share/tags/cfish/handlers/#ATTRIBUTES.name#.cfm")>
				<cfscript>
				VARIABLES.attr = duplicate(ATTRIBUTES);
				structAppend(VARIABLES.attr,content.getBlockContentAttributes(),FALSE);
				</cfscript>
				<cfoutput><cfinclude template="/share/tags/cfish/renderers/#ATTRIBUTES.name#.cfm"></cfoutput>
			<cfelse>
				<cfoutput>#content.getBlockContent(ATTRIBUTES.name)#</cfoutput>
			</cfif>
		</cfcase>
		<cfdefaultcase>
			<cfoutput>If it ain't broke this will not show, FIX IT!</cfoutput>
		</cfdefaultcase>
	</cfswitch><cfset thisTag.generatedContent = ""><!---<cfif ATTRIBUTES.name != "navmenu">
			<cfdump var="#getBaseTagList()#">
			<cfdump var="#ATTRIBUTES#">
			<cfdump var="#content.getBlockContent(name:'navmenu')#"><cfabort></cfif>--->
</cfif><cfsetting enablecfoutputonly="false"><cfset thisTag.generatedContent="">