<cfsetting enablecfoutputonly="true">
<cfswitch expression="#thisTag.executionMode#">
	<cfcase value="start">
		<cfparam name="attributes.id" default="">
		<cfparam name="attributes.value" default="">
		<cfparam name="attributes.src" default="">
		<cfparam name="attributes.position" default="">
		<cfparam name="attributes.before" default="">
		<cfparam name="attributes.after" default="">
		<cfparam name="attributes.type" default="css">
		<cfparam name="attributes.skip" default="false">
		<cfif ATTRIBUTES.skip><cfExit method="exittag"></cfif>

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
		<cfscript>
		attributes.type="css";
		standardAttributes = 'id';
		attributes = root.collaborate.mergeAttributes(attributes,root);
		attributeList = root.collaborate.createAttributeList(attributes,standardAttributes,root);
		</cfscript>
	</cfcase>
	<cfcase value="end">
		<cfscript>
		if(! len(trim(attributes.value))){
			attributes.value = trim(thisTag.generatedContent);
		}
		if(! len(trim(attributes.src))){
			attributes.content = attributes.value;
			if(len(trim(attributes.value)) && ! refindnocase("\s*<style",attributes.content)){
				attributes.content = "
	<style>#attributes.content#</style>";
			}
		}

		root.collaborate.content.addHeadContent(argumentCollection:attributes);

		thisTag.generatedContent = "";
		</cfscript>
	</cfcase>
</cfswitch>
<cfsetting enablecfoutputonly="false">