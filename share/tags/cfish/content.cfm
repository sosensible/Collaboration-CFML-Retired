<cfsetting enablecfoutputonly="true" /><cfif thisTag.executionMode EQ "start">
	<cfparam name="ATTRIBUTES.mode" default="append" />
	<cfparam name="ATTRIBUTES.type" default="standard" />
	<cfif NOT structKeyExists(ATTRIBUTES,"handler")>
		<cfthrow type="cfish.handler" message="Missing handler attribute."
			detail="You must include a handler attribute. (sidebarblock,etc.)" />
	</cfif>
	<cfif NOT structKeyExists(ATTRIBUTES,"cfish")>
		<cfthrow type="cfish.content" message="Missing CFish Object."
			detail="You must pass in the CFish object." />
	</cfif>
</cfif><cfsetting enablecfoutputonly="false" />
<cfif thisTag.executionMode EQ "end"><cfinclude template="#ATTRIBUTES.cfish.getPath()#skin/#ATTRIBUTES.cfish.getSkin()#/handler/store/#ATTRIBUTES.handler#.cfm" />
<cfset thisTag.generatedContent = "" /></cfif>