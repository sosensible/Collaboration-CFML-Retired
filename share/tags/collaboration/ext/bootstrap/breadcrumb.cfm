<cfsetting enablecfoutputonly="yes">
<cfif thisTag.executionMode EQ "start">
</cfif><cfsetting enablecfoutputonly="no"><cfif thisTag.executionMode EQ "end"><cfoutput><ul class="breadcrumb">#thisTag.generatedContent#</ul></cfoutput><cfset thisTag.generatedContent=""></cfif>