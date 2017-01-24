<cfsetting enablecfoutputonly="true">
	<cfswitch expression="#thisTag.executionMode#">
		<cfcase value="start">
			<!--- The id attribute is required. --->
			<cfparam name="attributes.id" type="string" default="">
			<cfparam name="attributes.class" type="string" default="">
			<cfparam name="attributes.value" type="string" default="">
			<!--- ensure the tag's required attributes are passed in --->

			<!--- href is required, it can be: http://whatever.com/...foo.cfm or foo.cfm --->
			<cfparam name="attributes.href" type="string" default="">

			<!--- assign the href to result --->
			<cfif StructKeyExists(caller,'root')>
				<cfset root = caller.root>
			<cfelse>
				<cfset root = caller>
			</cfif>
			<cfif NOT thisTag.hasEndTag>
				<cfthrow detail="End tag required" message="All Collaboration tags require an end tag." errorcode="collaboration.tag.attributes">
			</cfif>
			<!---<cfif attributes.id EQ ''>
				<cfthrow detail="Missing required attribute: 'id'" message="'id' attribute is required">
			</cfif>--->
			<!--- Test for the existence of the Collaboration framework. This will either be through a base Collaborate tag, or it must pre-exist. --->
			<cfif NOT structKeyExists(root,"collaborate")>
				<cfthrow detail="Missing required collaborate object on calling page.">
			</cfif>
			<!--- This segment is what interacts with the CoProcessor... It checks to see if the CoProcessor set any integrated or non-integrated attributes --->
			<cfscript>
			// tag logic start
			if(!listContainsNoCase(ATTRIBUTES.class,"brand"," ")){
				ATTRIBUTES.class = listAppend(ATTRIBUTES.class,"brand"," ");
			}
			// tag logic end
			standardattributes = 'id,formatter,formatterMask,formatterType,formatterVersion,href,qstring,type,showKeys,extension,value,rename';
			attributes = root.collaborate.mergeAttributes(attributes,root);
			attributeList = root.collaborate.createAttributeList(attributes,standardAttributes,root);
			</cfscript>
			<cfif attributes.href EQ ''>
				<!--- I check for the href attribute here and not above because I want the coProcessor to be able to set attributes. --->
				<cfthrow message="Missing required attribute HREF on element '#attributes.id#'">
			</cfif>
			<cfset result = attributes.href />
			<cfif isDefined("attributes.qString") && len(attributes.qString)>
				<cfif right(attributes.href,1) EQ '?' OR right(attributes.href,1) EQ '&'>
					<cfset result = "#result##attributes.qString#">
				<cfelseif findNoCase(attributes.href,"?")>
					<cfset result = "#result#&#attributes.qString#">
				<cfelse>
					<cfset result = "#result#?#attributes.qString#">
				</cfif>
			</cfif>
		</cfcase>
		<cfcase value="end">
			<!--- This allows the link value to be set using the value attribute or the generatedContent --->
			<cfif attributes.value EQ ''>
				<cfset attributes.value = thisTag.generatedContent>
			</cfif>
			<cfif isDefined("attributes.formatter") && len(attributes.formatter)>
				<cfset attributes.value = root.collaborate._formatter(attributes.formatter,attributes.value,attributes)>
			</cfif>
			<cfoutput>  <!--- Add in non-Collaboration attributes with the #attributeList# feature used below. --->
				<a id="#attributes.id#" href="#result#"#attributeList#>#attributes.value#</a>
			</cfoutput> 
		<cfset thisTag.GeneratedContent = "" />
		</cfcase>
	</cfswitch>
<cfsetting enablecfoutputonly="false">
<!--- <cfset elementName = "a"><cfinclude template="_base.cfm" /> --->