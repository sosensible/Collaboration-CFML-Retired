<cfcomponent extends="share.objects.collaboration.collaborate">
<!---
	<cfoutput>HELLO</cfoutput>
	<cfabort>
--->
	<cffunction name="onPageStart" access="public" output="false">
		<cfargument name="preDom" />
		
		<cfscript>
		var _preDom = ARGUMENTS.preDom;
		var ATTRIBUTES = _preDom.attributes;
		
		if(structKeyExists(ATTRIBUTES,'skin')){
			if(listContains(SESSION._skins,ATTRIBUTES.skin)){
				SESSION._skin = ATTRIBUTES.skin;
				_location('/apps/main/opensource.cfm?library=cfish');
				/*
				writeDump(VARIABLES);
				abort;
				*/
			}
		}
/*
	writeDump(ATTRIBUTES.);
	abort;
*/	
		return _preDom;
		</cfscript>
	</cffunction>
</cfcomponent>