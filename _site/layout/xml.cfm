<!--- for rendering XML content
 ---><cfimport prefix="cfish" taglib="/share/tags/cfish/">
<cfimport prefix="boot" taglib="/share/tags/collaboration/ext/bootstrap/">
<cfscript>
VARIABLES.siteMenu = [
	{
		type = "link",
		display = "About",
		link = "/apps/main/about.cfm"
	},{
		type = "link",
		display = "Blog",
		link = "/apps/blog/"
	},{
		type = "link",
		display = "Contact",
		link = "/apps/main/contact.cfm"
	},{
		type = "submenu",
		display = "Open Source",
		value = [
			{
				type = "link",
				display = "General",
				link = "/apps/labs/"
			},{
				type = "divider"
			},{
				type = "link",
				display = "Appestry",
				link = "/apps/labs/project/main.cfm?project=appestry"
			
			},{
				type = "link",
				display = "CFish",
				link = "/apps/labs/project/main.cfm?project=cfish"
			
			},{
				type = "link",
				display = "Collaboration",
				link = "/apps/labs/project/main.cfm?project=collaboration"
			}
		]
	},{
		type = "link",
		display = "Admin",
		link = "/apps/admin/",
		permission = "main_admin"
	}
];
</cfscript>
		<cfish:block name="sitebar" mode="set">
			<cfish:block name="navbarBrand" mode="paramRender" href="/">SOSensible</cfish:block>
			<cfish:block name="navmenu" data="#VARIABLES.siteMenu#" mode="paramRender"></cfish:block>
			<cfish:block name="navright" mode="paramRender">
				<div class="nav-collapse">
					<form action="/apps/main/search.cfm" class="navbar-search pull-right">
						<input type="text" class="search-query" placeholder="Search" />
					</form>
				</div>
			</cfish:block>
		</cfish:block>
		  
		  
		<cfish:block name="footer" mode="param">
			<cfish:block name="extBody" mode="render" />
			<p>&copy; SOSensible <cfoutput>#year(now())#</cfoutput></p>
		</cfish:block>

<cfish:skin name="#request._skin.get_name()#" />