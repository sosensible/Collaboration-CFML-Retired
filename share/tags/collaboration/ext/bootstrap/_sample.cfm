<cfsetting enablecfoutputonly="yes">
<cfif thisTag.executionMode EQ "start">
</cfif><cfsetting enablecfoutputonly="no"><cfif thisTag.executionMode EQ "end"><cfoutput>#thisTag.generatedContent#</cfoutput><cfset thisTag.generatedContent=""></cfif>