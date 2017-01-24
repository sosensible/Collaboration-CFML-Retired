<cfparam name="VARIABLES.attr.class" default=""><cfscript>
myClass = listAppend("hero-unit",VARIABLES.attr.class," ");
</cfscript>			<cfoutput><div class="#myClass#">
#REQUEST._content.getBlockContent(name:ATTRIBUTES.name)#
			</div></cfoutput>