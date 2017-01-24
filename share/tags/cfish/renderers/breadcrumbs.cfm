<cfscript>
VARIABLES._crumbs = REQUEST._content.getBlockContent(name:ATTRIBUTES.name);
</cfscript><cfif len(VARIABLES._crumbs)><cfif ATTRIBUTES.mode EQ "render">
			<ul class="breadcrumb"></cfif>
<cfoutput>#REQUEST._content.getBlockContent(name:ATTRIBUTES.name)#</cfoutput>
<cfif ATTRIBUTES.mode EQ "render">			</ul>
</cfif></cfif>