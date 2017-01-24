<cfimport prefix="cfish" taglib="/share/tags/cfish" />
<cfimport prefix="co" taglib="/share/tags/collaboration" />
<cfparam name="form.library" default="all" />
<cfif form.library NEQ "all">
<cfish:block name="breadcrumbs">				<li><a href="/apps/main/opensource.cfm">Open Source Projects</a></li></cfish:block>
</cfif>
<cfif form.library EQ "all">
		
<div class="row">
	<div class="hero-unit">
		<img src="/apps/main/_app/media/dep_11112092-Open-Source_crop.jpg" alt="About"  style="float:right;margin-bottom:6px;height:180px;border:2px solid black;" />
		<h1>SOSensible Labs</h1>
		<p>These are the open source projects sponsored by SOSensible and with generous help and contributions by the community at large.</p>
		<br style="clear:both;" />
	</div>
	<div class="span4">
		<h2>APPestry</h2>
		<p>APPestry is an application framework to provide a shared solution for distributed applications on the web platform.</p>
		<p>
			<div class="hero-unit" style="padding:10px;">
				<strong>Business/Site Owner</strong><br/>
				<em> Get your site online fast with flexibility to adapt to how you do business.</em>
			</div>
			<div class="hero-unit" style="padding:10px;">
				<strong>Designer</strong><br/>
				<em>Stylize sites with universal control from prototype to production.</em>
			</div>
			<div class="hero-unit" style="padding:10px;">
				<strong>Developer</strong><br/>
				<em>Build sites an APP at a time that look good and let you focus on the code.</em>
			</div>
		</p>
		<p><a class="btn" href="/apps/main/opensource.cfm?library=appestry">View APPestry &raquo;</a></p>
	</div>
	<div class="span4">
		<h2>CFish</h2>
		<p>CFish (a.k.a. cuttlefish) is the skinning library for CFML currently entering into version 3.</p>
		<p>
			<div class="hero-unit" style="padding:10px;">
				<strong>Business/Site Owner</strong><br/>
				<em>Your site with your personality.</em>
			</div>
			<div class="hero-unit" style="padding:10px;">
				<strong>Designer</strong><br/>
				<em>Elegant and robust control over design.</em>
			</div>
			<div class="hero-unit" style="padding:10px;">
				<strong>Developer</strong><br/>
				<em>CFish is MVC layouts empowered!</em>
			</div>
		</p>
		<p><a class="btn" href="/apps/main/opensource.cfm?library=cfish">View CFish &raquo;</a></p>
	</div>
	<div class="span4">
		<h2>Collaboration</h2>
		<p>Collaboration is the refactor of our COOP technology. We have moved this and our other key frameworks to think business first then to take the strengths of the framework into an active role.</p>
		<p>
			<div class="hero-unit" style="padding:10px;">
				<strong>Business/Site Owner</strong><br/>
				<em>Custom projects are easier to build and faster delivery and support.</em>
			</div>
			<div class="hero-unit" style="padding:10px;">
				<strong>Designer</strong><br/>
				<em>Focus on content and usability uncluttered from application code.</em>
			</div>
			<div class="hero-unit" style="padding:10px;">
				<strong>Developer</strong><br/>
				<em>Build solid application logic and intereact with view without focusing on managing the view.</em>
			</div>
		</p>
		<p><a class="btn" href="/apps/main/opensource.cfm?library=collaboration">View Collaboration &raquo;</a></p>
	</div>
</div>

<cfelseif form.library EQ "appestry">

<cfish:block name="breadcrumbs" mode="append">				<li><span class="divider">/</span><a href="/apps/main/opensource.cfm?library=appestry">APPestry</a></li></cfish:block>
<div class="row">
	<h1>APPestry</h1>
	<p>The official home page of the APPestry Framework.</p>
</div>
<div class="row">
				More to follow.
	<!---<iframe id="forum_embed"
	  src="javascript:void(0)"
	  scrolling="no"
	  frameborder="0"
	  width="900"
	  height="700">
	</iframe>
	<script type="text/javascript">
	  document.getElementById('forum_embed').src =
		 'https://groups.google.com/a/sosapps.com/forum/embed/?place=forum/appestry-grp'
		 + '&showsearch=true&showpopout=true&showtabs=false'
		 + '&parenturl=' + encodeURIComponent(window.location.href);
	</script>--->
</div>

<cfelseif form.library EQ "cfish">

<cfish:block name="breadcrumbs" mode="append">				<li><span class="divider">/</span><a href="/apps/main/opensource.cfm?library=cfish">CFish</a></li></cfish:block>

<co:collaborate>
<div class="row">
	<h1>CFish</h1>
	<p>The official home page of the CFish library.</p>
</div>

<cfparam name="URL._skin" default="bootstrap">
<cfscript>
deviceWidths = [
	{
		display = "Phone",
		value = 480
	},{
		display = "Phablet",
		value = 600
	},{
		display = "Tablet",
		value = 768
	},{
		display = "( default )",
		value = 960
	},{
		display = "Large",
		value = 1200
	}
];
</cfscript>
	
<div class="row">
	<!---
	<co:list id="skin_picks" data="#SESSION._skins#" link="/apps/main/opensource.cfm?library=cfish&skin=" linkfield="value" />
	--->
	
	<!---
	<div class="dropdown"><a class="dropdown-toggle btn" data-toggle="dropdown" href="#" style="float:left;margin-right:9px;">Skin</a>
	<co:list id="skin_picks" class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu" data="#SESSION._skins#" link="javascript:setPreviewSkin('" postLink="')" linkfield="value" />
	</div>
	<div class="dropdown"><a class="dropdown-toggle btn" data-toggle="dropdown" href="##" style="float:left;margin-right:9px;">Width</a>
	<co:list id="preview_size" class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu" data="#deviceWidth#" link="javascript:setPreviewWidth('" postLink="')" linkfield="value" />
	</div> --->
	<cfoutput><cfish:block name="extBody" mode="set">
	<cfish:block name="navbar" mode="render">
			<ul class="nav">
				<li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="##">Skins<b class="caret"></b></a>
					<co:list id="skin_picks" data="#SESSION._skins#" class="dropdown-menu" link="javascript:setPreviewSkin('" postLink="')" linkfield="value" />
				</li>
				<li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="##">Devices<b class="caret"></b></a>
					<co:list id="preview_size" data="#deviceWidths#" class="dropdown-menu" link="javascript:setPreviewWidth('" postLink="')" linkfield="value" />
				</li>
			</ul>
	</cfish:block>
	<div style="clear:both;">
	<iframe id="preResponsive" width="960" height="640" src="/apps/main/about.cfm?library=collaboration&_skin=#URL._skin#"></iframe>
</div>
	<co:script id="skinPreview">
	setPreviewSkin = function(skin){
		jQuery('##preResponsive').attr("src",'/apps/main/about.cfm?library=collaboration&_skin='+skin);
	}
	setPreviewWidth = function(width){
		jQuery('##preResponsive').attr("width",width);
	}
	</co:script>
	</cfish:block></cfoutput>
	
	<!---
	<cfdump var="#SESSION#" top="2">
	<co:form id="cfish_skin">
		<co:selectlist id="skin_pick" data="#SESSION._skins#" selected="#SESSION._skin#" />
		<co:submit id="sbm_skin" value="SELECT SKIN" />
	</co:form>
	<iframe id="forum_embed"
	  src="javascript:void(0)"
	  scrolling="no"
	  frameborder="0"
	  width="900"
	  height="700">
	</iframe>
	<script type="text/javascript">
	  document.getElementById('forum_embed').src =
		 'https://groups.google.com/a/sosapps.com/forum/embed/?place=forum/cfish-grp'
		 + '&showsearch=true&showpopout=true&showtabs=false'
		 + '&parenturl=' + encodeURIComponent(window.location.href);
	</script>--->
</div>

</co:collaborate>

<cfelseif form.library EQ "collaboration">

<cfish:block name="breadcrumbs" mode="append">				<li><span class="divider">/</span><a href="/apps/main/opensource.cfm?library=collaboration">Collaboration</a></li></cfish:block>
<div class="row">
	<img src="/apps/main/_app/media/collaboration_logo.jpg" style="float:left;padding-right:10px;" />
	<h1>Collaboration</h1>
	<p>The offical home page of the Collaboration library.</p>
</div>
<div class="row">

	<div class="span9">
		<div class="row">
			<div class="span9">
				<h2>News</h2>
			</div>
		</div>
		<div class="row">
			<div class="span3">Left Left Left Left Left Left Left Left Left Left Left Left Left Left Left Left Left Left Left Left Left Left Left Left Left Left Left Left Left Left Left Left Left Left Left Left Left Left Left Left Left Left Left </div>
			<div class="span3">Middle Middle Middle Middle Middle Middle Middle Middle Middle Middle Middle Middle Middle Middle Middle Middle Middle Middle Middle Middle Middle Middle Middle Middle Middle Middle Middle Middle </div>
			<div class="span3">Right Right Right Right Right Right Right Right Right Right Right Right Right Right Right Right Right Right Right Right Right Right Right Right Right Right Right Right Right Right Right Right Right Right Right Right Right Right Right Right Right Right Right Right Right Right </div>
		</div>
		<div class="row">
			<div class="span9">
				More to follow.
			<!---
					<iframe id="forum_embed"
					  src="javascript:void(0)"
					  scrolling="no"
					  frameborder="0"
					  width="100%"
					  height="700">
					</iframe>
					<script type="text/javascript">
					  document.getElementById('forum_embed').src =
						 'https://groups.google.com/a/sosapps.com/forum/embed/?place=forum/collaboration-grp'
						 + '&showsearch=true&showpopout=true&showtabs=false'
						 + '&parenturl=' + encodeURIComponent(window.location.href);
					</script>--->
			</div>
		</div>
	</div>
	
	<div class="span3">
		<div class="well sidebar-nav">
			Links:
			<ul>
				<li><a href="##">Blog</a></li>
				<li><a href="##">Docs</a></li>
				<li><a href="##">Download</a></li>
				<li><a href="##">Discussion List</a></li>
				<li><a href="##">Issue Tracker</a></li>
				<li><a href="##">Newsletter</a></li>
			</ul>
		</div>
	</div>
</div>

</cfif>
