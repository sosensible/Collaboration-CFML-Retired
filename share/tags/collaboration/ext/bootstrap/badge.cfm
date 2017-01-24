<cfsetting enablecfoutputonly="yes">
<cfif thisTag.executionMode EQ "start">
	<cfif structKeyExists(ATTRIBUTES,"type")>
		<cfswitch expression="#ATTRIBUTES.type#">
			<cfcase value="important">
				<cfset extClass = " badge-important">
			</cfcase>
			<cfcase value="info">
				<cfset extClass = " badge-info">
			</cfcase>
			<cfcase value="inverse">
				<cfset extClass = " badge-inverse">
			</cfcase>
			<cfcase value="success">
				<cfset extClass = " badge-success">
			</cfcase>
			<cfcase value="warning">
				<cfset extClass = " badge-warning">
			</cfcase>
			<cfdefaultcase>
				<cfset extClass = "">
			</cfdefaultcase>
		</cfswitch>
	</cfif>
</cfif><cfsetting enablecfoutputonly="no"><cfif thisTag.executionMode EQ "end"><cfoutput><span class="badge#extClass#">#thisTag.generatedContent#</span></cfoutput><cfset thisTag.generatedContent=""></cfif>