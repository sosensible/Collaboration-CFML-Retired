<cfimport prefix="cfish" taglib="/share/tags/cfish/"><cfif ATTRIBUTES.mode EQ "render">
<div class="navbar navbar-inverse navbar-fixed-top">
	<div class="navbar-inner">
		<div class="container"><cfelse><cfoutput>#thisTag.generatedContent#</cfoutput></cfif><cfif ATTRIBUTES.mode EQ "render"><cfoutput>#REQUEST._content.getBlockContent(name:ATTRIBUTES.name)##thisTag.generatedContent#</cfoutput>
		</div>
	</div>
</div></cfif>