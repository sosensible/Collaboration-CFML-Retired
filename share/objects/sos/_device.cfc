<cfcomponent extends="share.objects.sos.fbo">

	<cfproperty name="site" type="dio" dioclass="@@application@@.@site@.site" dioname="site" dioaccess="private" />

	<cffunction name="onFactoryCreate" access="public">
		<cfscript>
	//	arrayAppend(REQUEST._log,{loc='BASE_device.onFactoryCreate()',note='((before init))'});
		init(allow:variables.site.get_devices());
	//	arrayAppend(REQUEST._log,{loc='BASE_device.onFactoryCreate()',device='VARIABLES.device exists?=~~#listFindNoCase(structKeyList(VARIABLES),"device")#'});
		</cfscript>
	</cffunction>

	<cffunction name="init" access="public">
		<cfargument name="allow" default="android,blackberry,iPhone,iPod_Touch,iPad,operaMini,mobile" hint="mobile covers the other devices as able">
		<cfargument name="allowFlash" default="true">
		<cfscript>
		//setup vars
		var agent = "";
		var i = 0;
	//	writeDump("...device constructor called...");abort();
		setDefaults();

		VARIABLES.baseDevice = 'browser';
		VARIABLES.is = {
			mobile = false,
			FlashAble = false,
			AppleDevice = false,
			tablet = false
		};
		VARIABLES.allow={
			android = false,
			blackberry = false,
			iPhone = false,
			iPod_Touch = false,
			iPad = false,
			operaMini = false,
			mobile = false
		};

		for(i=1;i <= listLen(arguments.allow);i++){
			VARIABLES.allow[listGetAt(arguments.allow,i)] = true;
		}

		if(structKeyExists(CGI,"HTTP_USER_AGENT")){
			VARIABLES.agent = CGI.HTTP_USER_AGENT;

			if(isDevice('android')){
				variables.is.mobile = true;
				if(ARGUMENTS.allowFlash){
					variables.is.FlashAble = true;
				}
				VARIABLES.baseDevice = 'android';
			} else if(isDevice('blackberry')){
				variables.is.mobile = true;
				VARIABLES.baseDevice = 'blackberry';
			} else if(isDevice('ipod')){
				variables.is.mobile = true;
				VARIABLES.baseDevice = 'iPod_Touch';
				VARIABLES['showDevice'] = 'iPhone';
			} else if(isDevice('iphone')){
				variables.is.mobile = true;
				VARIABLES.baseDevice = 'iPhone';
			} else if(isDevice('ipad')){
				variables.is.mobile = true;
				VARIABLES.baseDevice = 'iPad';
				variables.is.tablet = true;
			} else if(isDevice('opera mini')){
				variables.is.mobile = true;
				VARIABLES.baseDevice = 'operaMini';
			} else if(isDevice('(#VARIABLES.mobileKeyWords#)')){
				variables.is.mobile = true;
				VARIABLES.baseDevice = 'mobile';
			} else if(isDevice('(#VARIABLES.mobileBrowsers#)')){
				variables.is.mobile = true;
				VARIABLES.baseDevice = 'mobile';
			} else {
				for(i=1;i <= listLen(VARIABLES.otherCGI);i++){
					if(structKeyExists(CGI,listGetAt(VARIABLES.otherCGI,i))){
						variables.isMobile = true;
					}
				}
			}
			if(!structKeyExists(VARIABLES,"showDevice")){
				VARIABLES['showDevice'] = VARIABLES.baseDevice;
			} else {
				VARIABLES['@showDevice'] = VARIABLES.baseDevice;
			}
		}
	//	writeDump(variables);abort;
		arrayAppend(REQUEST._log,{loc='BASE_device.init()',device='VARIABLES.device exists?=~~#listFindNoCase(structKeyList(VARIABLES),"device")#'});
		return this;
		</cfscript>
	</cffunction>

	<cffunction name="get_v" access="public" output="false">
		<cfreturn VARIABLES>
	</cffunction>

	<cffunction name="get_agent" access="public" output="false">
		<cfreturn VARIABLES.agent>
	</cffunction>

	<cffunction name="get_baseDevice" access="public" output="false">
		<cfreturn VARIABLES.baseDevice>
	</cffunction>

	<cffunction name="get_device" access="public" output="true">
		<cftry>
			<cfreturn VARIABLES.showDevice>
			<cfcatch>
				<cfset arrayAppend(REQUEST._log,{loc='_device.get_device()',note='~~#structKeyList(VARIABLES)#',stucture=VARIABLES})>
				<cfdump var="#REQUEST._log#">
				<cfdump var="#variables#" label="wh = #structKeyList(APPLICATION.__objectWarehouse)#">
				<cfdump var="#cfcatch#" label="get_device">
				<cfabort>
				<CFThrow type="sos.debug" detail="missing internal persistance">
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="isMobile" access="public" output="false">
		<cfreturn VARIABLES.is.mobile>
	</cffunction>

	<cffunction name="isFlashAble" access="public" output="false">
		<cfreturn VARIABLES.is.FlashAble>
	</cffunction>

	<!--- Private Functions --->
	<cffunction name="isDevice" access="private" output="false">
		<cfargument name="device">
		<cfscript>
		if(structKeyExists(variables.allow,ARGUMENTS.device) && 
				variables.allow[ARGUMENTS.device] &&
				findNoCase(ARGUMENTS.device,VARIABLES.agent)){
			return true;
		} else {
			return false;
		}
		</cfscript>
	</cffunction>

	<cffunction name="setDefaults" access="private" output="false">
		<cfscript>
		VARIABLES.mobileKeywords = "iemobile|kindle|midp|mini|mmp|mobile|o2|pda|phone|pocket|psp|smartphone|symbian|treo|vodafone|up.browser|up.link|wap|windows ce";
		VARIABLES.mobileBrowsers = "acs-|alav|alca|amoi|audi|aste|avan|benq|bird|blac|blaz|brew|cell|cldc|cmd-|dang|doco|eric|hipt|inno|ipaq|java|jigs|kddi|keji|leno|lg-c|lg-d|lg-g|lge-|maui|maxo|midp|mits|mmef|mobi|mot-|moto|mwbp|nec-|newt|noki|opwv|palm|pana|pant|pdxg|phil|play|pluc|port|prox|qtek|qwap|sage|sams|sany|sch-|sec-|send|seri|sgh-|shar|sie-|siem|smal|smar|sony|sph-|symb|t-mo|teli|tim-|tosh|tsm-|upg1|upsi|vk-v|voda|w3c|wap-|wapa|wapi|wapp|wapr|webc|winw|winw|xda|xda-";
		VARIABLES.otherCGI = "HTTP_X_WAP_PROFILE,HTTP_PROFILE,X-OperaMini-Features,UA-pixels";
		</cfscript>
	</cffunction>

</cfcomponent>