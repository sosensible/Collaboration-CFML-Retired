<cfsetting enablecfoutputonly="true" /><cfif thisTag.executionMode EQ "start">
	<cfif NOT structKeyExists(ATTRIBUTES,"handler")>
		<cfthrow type="cfish.render" message="Missing handler attribute."
			detail="You must include a handler attribute. (sidebarblock,etc.)" />
	</cfif>
	<cfif NOT structKeyExists(ATTRIBUTES,"cfish")>
		<cfthrow type="cfish.render" message="Missing CFish Object."
			detail="You must pass in the CFish object." />
	</cfif>
</cfif><cfsetting enablecfoutputonly="false" />
<cfif thisTag.executionMode EQ "end"><!---..<cfdump var="#(ATTRIBUTES.cfish.content())#"><cfabort>---><cfset content = ATTRIBUTES.cfish.content()><cfif structKeyExists(content,ATTRIBUTES.handler)><cfscript>
cData = content[ATTRIBUTES.handler];
thisTag.generatedContent = "";
</cfscript><cfinclude template="#ATTRIBUTES.cfish.getPath()#skin/#ATTRIBUTES.cfish.getSkin()#/handler/render/#ATTRIBUTES.handler#.cfm" /></cfif></cfif>