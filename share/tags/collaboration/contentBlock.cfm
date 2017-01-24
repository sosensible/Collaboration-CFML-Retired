<cfsetting enablecfoutputonly="true">
<cfswitch expression="#thisTag.executionMode#">
	<cfcase value="start">
		<cfparam name="attributes.id" default="">
		<cfparam name="attributes.wrapElement" default="div">
		<cfparam name="attributes.skip" default="false">
		<cfparam name="attributes.value" default="">
		<cfparam name="attributes.preBlockContent" default="">
		<cfparam name="attributes.postBlockContent" default="">

		<cfif StructKeyExists(caller,'root')>
			<cfset root = caller.root>
		<cfelse>
			<cfset root = caller>
		</cfif>
		<cfif NOT thisTag.hasEndTag>
			<cfthrow detail="End tag required" message="All Collaboration tags require an end tag." errorcode="collaboration.tag.attributes">
		</cfif>
		<cfif NOT structKeyExists(root,"collaborate")>
			<cfthrow detail="Missing required collaborate object on calling page.">
		</cfif>
		<cfif attributes.id EQ ''>
			<cfthrow detail="Missing required attribute: 'id'" message="'id' attribute is required">
		</cfif>
		<cfscript>
		standardattributes = 'id,wrapElement,skip,preBlockContent,postBlockContent,value';
		attributes = root.collaborate.mergeattributes(attributes,root);
		attributeList = root.collaborate.createAttributeList(attributes,standardAttributes,root);
		</cfscript>
		<cfif attributes.skip>
			<cfsetting enablecfoutputonly="false">
			<cfexit method="exitTag">
		</cfif>
	</cfcase>
	<cfcase value="end">
		<cfscript>
		if (attributes.value EQ '' AND thisTag.generatedContent NEQ '')
		{
			attributes.value = thisTag.generatedContent;
		}
		if(attributes.value NEQ ''){
			formElement = '<#attributes.wrapElement# id="#attributes.id#"#attributeList#>#attributes.preBlockContent##attributes.value##attributes.postBlockContent#</#attributes.wrapElement#>';
		} else {
			formELement = '';
		}
		</cfscript>
		<cfoutput>#formElement#</cfoutput>
		<cfset thisTag.GeneratedContent = ''>
	</cfcase>
</cfswitch>
<cfsetting enablecfoutputonly="false">