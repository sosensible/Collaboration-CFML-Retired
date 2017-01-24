<!--- 1.5.0.2 (Build 16) --->
<!--- Last Updated: 2009-07-09 --->
<!--- Created by John Farrar 2007-10-10 --->
<!--- Information: sosapps.com --->
<cfcomponent extends="factory" displayname="Object Factory for SOS" hint="I am the SOS Application Framework implementation of sosFactory">

	<cffunction name="setTranslators" displayname="setTranslators" hint="I set the translators for this environment." output="false">
		<cfscript>
		super.setTranslators();

		VARIABLES.translate['@site@'] = 'site';
		VARIABLES.translate['@app@'] = 'app';
		VARIABLES.translate['@subapp@'] = 'subapp';
		VARIABLES.translate['@share@'] = 'share';
		</cfscript>
	</cffunction>

	<cffunction name="translateClass" output="true" access="public" 
		displayname="translateClass" 
		hint="I translate the a class path alias if found.">
		<cfargument name="class" required="true" type="string" 
			displayname="class" hint="I am the class path with a possible translation hinted alias." />
		<cfscript>
		var keys = structKeyList(VARIABLES.translate);
		var key = "";
		var reKey = "";
		var reTmp = "";
		var tKey = "";
		var position = 0;
		var rePosition = 0;
		var i = 0;
		for(i=1;i<=listLen(keys);i++){
			key = listGetAt(keys,i);
			reKey = "@#VARIABLES.translate[key]#:\w+@";
			if(refind(reKey,ARGUMENTS.class)&&find(ARGUMENTS.class,":")){
				tKey = VARIABLES.translate[key];
				rePosition = refind(reKey,ARGUMENTS.class,1,1);
				tmp1 = rePosition.pos[1]+len(tKey)+2;
				tmp2 = rePosition.len[1]-3-len(tKey);
				reTmp = mid(ARGUMENTS.class,tmp1,tmp2);
				if(structKeyExists(APPLICATION,"_#tKey#")){
					if(structKeyExists(APPLICATION["_#tKey#"],reTmp)){
						reKey = "@#tKey#:#reTmp#@";
						ARGUMENTS.class = replace(ARGUMENTS.class,reKey,APPLICATION["_#tKey#"][reTmp].get_objectClassPath());
					}
				}
				position = 0;
			} else {
				position = listFindNoCase(ARGUMENTS.class,key,".");
				if(position){
					tKey = VARIABLES.translate[key];
					if(structKeyExists(REQUEST,"_api") && structKeyExists(REQUEST._api,tKey)){
						ARGUMENTS.class = listSetAt(ARGUMENTS.class,position,REQUEST._api[tKey].get_objectClassPath(),".");
					} else {
						if(structKeyExists(APPLICATION,"_#tKey#")){
							ARGUMENTS.class = listSetAt(ARGUMENTS.class,position,APPLICATION["_#tKey#"].get_objectClassPath(),".");
						} else if(isDefined("session") && structKeyExists(SESSION,"_#tKey#")){
							ARGUMENTS.class = listSetAt(ARGUMENTS.class,position,SESSION["_#tKey#"].get_objectClassPath(),".");
						} else {
							//	nothing
						}
						if(ARGUMENTS.class == "@site@.site"){
							ARGUMENTS.class = "_site.objects.site";
						}
					}
				}
			}
		}
		ARGUMENTS.class = REPLACE(ARGUMENTS.class,"..",".","ALL");

		return ARGUMENTS.class;
		</cfscript>
	</cffunction>

</cfcomponent>