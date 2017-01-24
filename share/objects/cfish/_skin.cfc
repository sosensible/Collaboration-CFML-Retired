<cfcomponent output="false">

	<cffunction name="init" displayname="CFish Skin object class" description="This is skin class to pass for the current skin on a site." 
		access="public" output="false">
		<cfargument name="skinName">
		<cfscript>
		VARIABLES['skin'] = {}; // preset structure base for skin metadata
		VARIABLES.skin['name'] = ARGUMENTS.skinName;

		return THIS;
		</cfscript>
	</cffunction>

	<cffunction name="get_mediaPath" displayname="get_mediaPath" description="I return the media path for the current skin." access="public" output="false">
		<cfreturn "#VARIABLES.getPath()#media/">
	</cffunction>

	<cffunction name="get_CSSPath" displayname="get_CSSPath" description="I return the CSS path for the current skin." access="public" output="false">
		<cfreturn get_path()>
	</cffunction>

	<cffunction name="get_name" displayname="get_name" description="I return the current skin name for the session user." access="public" output="false">
		<cfreturn VARIABLES.skin.name>
	</cffunction>

	<cffunction name="get_path" displayname="get_path" description="I return the current skin path for the session user." access="public" output="false">
		<cfreturn "/share/skin/#VARIABLES.skin.name#/">
	</cffunction>

</cfcomponent>