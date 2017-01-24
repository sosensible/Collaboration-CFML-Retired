<cfsetting enablecfoutputonly="yes">
<cfif thisTag.executionMode EQ "start">
	<cfif structKeyExists(ATTRIBUTES,"type")>
		<cfswitch expression="#ATTRIBUTES.type#">
			<cfcase value="important">
				<cfset extClass = " label-important">
			</cfcase>
			<cfcase value="info">
				<cfset extClass = " label-info">
			</cfcase>
			<cfcase value="inverse">
				<cfset extClass = " label-inverse">
			</cfcase>
			<cfcase value="success">
				<cfset extClass = " label-success">
			</cfcase>
			<cfcase value="warning">
				<cfset extClass = " label-warning">
			</cfcase>
			<cfdefaultcase>
				<cfset extClass = "">
			</cfdefaultcase>
		</cfswitch>
	</cfif>
</cfif><cfsetting enablecfoutputonly="no"><cfif thisTag.executionMode EQ "end"><cfoutput><span class="label#extClass#">#thisTag.generatedContent#</span></cfoutput><cfset thisTag.generatedContent=""></cfif>