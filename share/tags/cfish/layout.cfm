<cfsetting enablecfoutputonly="true">

<cfif thistag.executionMode EQ "start">
		<cfparam name="ATTRIBUTES.device" default="">
		<!--- devices: android,blackberry,browser,iPhone,mobile,operaMini --->
		<cfparam name="ATTRIBUTES.cfish" default="">
		<cfparam name="ATTRIBUTES.skin" default="">
		<cfparam name="ATTRIBUTES.meta" default="">
		<cfparam name="ATTRIBUTES.CSS" default="">
		<cfparam name="ATTRIBUTES.JS" default="">
		<cfparam name="ATTRIBUTES.item" default="">
		<cfparam name="ATTRIBUTES.allowCache" default="FALSE">
		<cfif NOT isObject(ATTRIBUTES.cfish)>
			<cfthrow message="You must pass in the cfish object via the object attribute">
		</cfif>
</cfif>

<cfif thistag.executionMode EQ "end">

<cfscript>
if(structKeyExists(ATTRIBUTES,"content")){
	sos.bufferContent = ATTRIBUTES.content;
	useContent = true;
} else {
	useContent = false;
}

_API = {
	cfish = ATTRIBUTES.cfish,
	site = APPLICATION._site
};
if(!len(trim(ATTRIBUTES.device))){
	ATTRIBUTES.device = _api.cfish.getDevice();
}
if(!fileExists("#_api.cfish.get_skinDirectory()##ATTRIBUTES.device#.cfm")){
	ATTRIBUTES.device = "browser";
}
</cfscript>
<cffunction name="getContent">
	<cfargument name="item" required="true">
	<cfset var retContent = "">
	<cfif useContent>
		<cfswitch expression="#lcase(ARGUMENTS.item)#">
			<cfcase value="css">
				<cfreturn ATTRIBUTES.content.getHeadCSSContent()>
			</cfcase>
			<cfcase value="js">
				<cfreturn ATTRIBUTES.content.getHeadJSContent()>
			</cfcase>
			<cfdefaultcase>
				<cfreturn ATTRIBUTES.content.getSimpleContent(ARGUMENTS.item)>
			</cfdefaultcase>
		</cfswitch>
	<cfelse>
		<cfif structKeyExists(ATTRIBUTES,ARGUMENTS.item)>
			<cfreturn ATTRIBUTES[ARGUMENT.item]>
		<cfelse>
			<cfreturn "">
		</cfif>
	</cfif>
</cffunction>
<cfoutput><cfinclude template="#_api.cfish.getPath()#skin/#ATTRIBUTES.skin#/#ATTRIBUTES.device#.cfm" /></cfoutput>
<cfset thisTag.generatedContent="">

</cfif>
<cfsetting enablecfoutputonly="false">