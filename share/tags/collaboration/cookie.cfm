<cfsetting enablecfoutputonly="true">
<cfswitch expression="#thisTag.executionMode#">
	<cfcase value="start">
		<cfparam name="attributes.id" default="">
		<cfparam name="attributes.name" default="">
		<cfparam name="attributes.value" default="">
		<cfparam name="attributes.domain" default="">
		<cfparam name="attributes.path" default="">
		<cfparam name="attributes.expires" default="">
		<cfparam name="attributes.secure" default="">
		<cfif StructKeyExists(caller,'root')>
			<cfset root = caller.root>
		<cfelse>
			<cfset root = caller>
		</cfif>
		<cfif NOT structKeyExists(root,"collaboration")>
			<cfthrow detail="Missing required collaboration object on calling page.">
		</cfif>
		<cfif NOT thisTag.hasEndTag>
			<cfthrow detail="End tag required" message="All Collaboration tags require an end tag." errorcode="collaboration.tag.attributes">
		</cfif>
		<cfif attributes.id EQ ''>
			<cfthrow detail="Missing required attribute: 'id'" message="'id' attribute is required">
		</cfif>
		<cfscript>
		standardattributes = 'id,name,value,domain,path,expires,secure';
		attributes = root.collaborate.mergeattributes(attributes,root);
		attributeList = root.collaborate.createAttributeList(attributes,standardAttributes,root);
		if (attributes.name EQ '') {
			attributes.name = attributes.id;
		}
	</cfscript>
	</cfcase>
	<cfcase value="end">
		<cfif attributes.value EQ ''>
			<cfset attributes.value = thisTag.generatedContent>
		</cfif>
		<cfset root.collaborate._createCookie(name:attributes.name,value:attributes.value,domain:attributes.domain,path:attributes.path,expires:attributes.expires,secure:attributes.secure)>
	</cfcase>
</cfswitch>
<cfsetting enablecfoutputonly="false">