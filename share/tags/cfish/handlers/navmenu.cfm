<cfif listContainsNoCase("render,paramRender",ATTRIBUTES.mode)><cfif structKeyExists(ATTRIBUTES,'data')><cfoutput>#renderNavMenu(ATTRIBUTES.data)#</cfoutput>
<cfelse>			<cfoutput><ul class="nav">
#REQUEST._content.getBlockContent(name:ATTRIBUTES.name)#
			</ul></cfoutput></cfif></cfif>
<cffunction name="renderNavMenu">
	<cfargument name="data">
	<cfargument name="nested" default="false">
	<cfscript>
	var _data = ARGUMENTS.data;
	var i = 0;
	var items = arrayLen(_data);
	var returnContent = "";
	var leadTabs = "			";
	if(ARGUMENTS.nested){ leadTabs &= "		";	}
	</cfscript>
	<cfsetting enablecfoutputonly="yes">
	<cfloop index="i" from="1" to="#items#">
		<cfif i EQ 1>
			<cfif ARGUMENTS.nested>
<cfoutput>#leadTabs#<ul class="dropdown-menu">
</cfoutput>
		<cfelse>
<cfoutput>#leadTabs#<ul class="nav">
</cfoutput></cfif></cfif>
		
		<cfswitch expression="#_data[i].type#">
		<cfcase value="divider">
<cfoutput>#leadTabs#	<li class="divider"></li>
</cfoutput>
		</cfcase>
		
		<cfcase value="link">
<cfoutput>#leadTabs#	<li><cfif structKeyExists(_data[i],"link")><a href="#_data[i].link#">#_data[i].display#</a><cfelse>#_data[i].display#</cfif></li>
</cfoutput>
		</cfcase>
		
		<cfcase value="submenu">
<cfoutput>#leadTabs#	<li class="dropdown"><a href="##" class="dropdown-toggle" data-toggle="dropdown">#_data[i].display#<b class="caret"></b></a>
#leadTabs#	#renderNavMenu(data=_data[i].value,nested=true)#
#leadTabs#	</li>
</cfoutput></cfcase>
			
	</cfswitch>
		<cfif i EQ items>
<cfoutput>#leadTabs#</ul>
</cfoutput>
		</cfif>
	</cfloop><cfsetting enablecfoutputonly="no">
	<cfreturn returnContent>
</cffunction>