<cfimport prefix="co" taglib="/share/tags/collaboration" />
<cfimport prefix="appestry" taglib="/share/tags/appestry" />
<cfimport prefix="cfish" taglib="/share/tags/cfish" />
	<cfish:block name="breadcrumbs" mode="set">
		<li><a href="/index.cfm/admin_app/apps/">APP List</a></li>
		<li><span class="divider">/</span>APP</li>
	</cfish:block>
	
	<!-- Example row of columns -->
	<div class="row">
		<img src="/apps/blog/_app/media/blog_logo_med.png" alt="About"  style="float:right;margin-bottom:6px;" />
		<co:h1 id="viewTitle">APP Admin</co:h1>
		<p>The Admin of the (<co:text id="appTxt" />) APP for SOSensible.</p>
	</div>
	
	<co:contentblock id="servantAdmin" skip="false">
		
		<em>The following content is requested via a servant oriented request. Rather than going over HTTP it is requested locally and displayed within the content. This is faster and scales better.</em>
		<appestry:appcall subapp="learn_admin" action="_appestry" />
		
	</co:contentblock>