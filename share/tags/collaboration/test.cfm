<cfparam name="ATTRIBUTES.name" default="bootstrap"><cfparam name="ATTRIBUTES.layout" default="default"><cfIf THISTAG.executionMode EQ "start">

<cfElseIf THISTAG.executionMode EQ "end"><cfinclude template="/share/skin/#ATTRIBUTES.name#/#ATTRIBUTES.layout#.cfm" />
<cfoutput>#thisTag.generatedContent#</cfoutput><cfset thisTag.generatedContent = ""></cfIf>