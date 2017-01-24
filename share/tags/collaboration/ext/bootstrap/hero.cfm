<cfsetting enablecfoutputonly="yes"><cfparam name="VARIABLES.attr.class" default="">
<cfif thisTag.executionMode EQ "start"><cfscript>
myClass = listAppend("hero-unit",VARIABLES.attr.class," ");
</cfscript>
</cfif><cfsetting enablecfoutputonly="no"><cfif thisTag.executionMode EQ "end"><cfoutput><div class="#myClass#">#thisTag.generatedContent#</div></cfoutput><cfset thisTag.generatedContent = ""></cfif>