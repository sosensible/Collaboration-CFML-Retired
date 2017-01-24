<cfcomponent extends="_device">
	<cffunction name="init" access="public">
		<cfargument name="allow" default="android,blackberry,iPhone,iPod_Touch,iPad,operaMini,mobile" hint="mobile covers the other devices as able">
		<cfargument name="allowFlash" default="true">
		<cfscript>
		arrayAppend(REQUEST._log,{loc='device.int()',note='((before SUPER.init))'});
		super.init(ARGUMENTS.allow,ARGUMENTS.allowFlash);
		arrayAppend(REQUEST._log,{loc='device.super.init()',device='VARIABLES.device exists?=~~#listFindNoCase(structKeyList(VARIABLES),"device")#'});
		return this;
		</cfscript>
	</cffunction>

</cfcomponent>