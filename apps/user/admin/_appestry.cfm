<cfimport prefix="co" taglib="/share/tags/collaboration/">

<div class="row">
	<div class="span12">
		<div class="well well-small">
			<co:h2 id="mySubtitle">Nested Content from another APP</co:h2>
		</div>
	</div>
</div>
<div class="row">
	<div class="span6">
		<div class="rowFluid">
			<div class="fluid12">
				<div class="well well-small">
					Have you ever wanted to pull view content from other APPs on your site?
				</div>
			</div>
			<div class="fluid12">
				<div class="well well-small">
					Can you do this safe, even to the point of AJAX requests?
				</div>
			</div>
		</div>
	</div>
	
	<div class="span6">
		<div class="well well-small">
			<strong>Benefits</strong>
			<co:list id="servantWinList" data="encapsulation (1),protected variable scope,uses own controller,cleaner code,isolated AJAX simpler,faster performance,better scale" />
			<em>(1) Includes are exposed and cross page variable manipulation is a risk.</em>
		</div>
	</div>
</div>
<div class="row">
	<div class="span12">
		<pre>
<strong>( THIS IS THE CALLING APP VIEW PAGE CODE )</strong>
&lt;cfimport prefix="co" taglib="/share/tags/collaboration" /&gt;
&lt;cfimport prefix="appestry" taglib="/share/tags/appestry" /&gt;
&lt;cfimport prefix="cfish" taglib="/share/tags/cfish" /&gt;
	&lt;cfish:block name="breadcrumbs" mode="set"&gt;
		&lt;li&gt;&lt;a href="/index.cfm/admin_app/apps/"&gt;APP List&lt;/a&gt;&lt;/li&gt;
		&lt;li&gt;&lt;span class="divider"&gt;/&lt;/span&gt;APP&lt;/li&gt;
	&lt;/cfish:block&gt;
	
	&lt;!-- Example row of columns --&gt;
	&lt;div class="row"&gt;
		&lt;img src="/apps/blog/_app/media/blog_logo_med.png" alt="About"  style="float:right;margin-bottom:6px;" /&gt;
		&lt;co:h1 id="viewTitle"&gt;APP Admin&lt;/co:h1&gt;
		&lt;p&gt;The Admin of the (&lt;co:text id="appTxt" /&gt;) APP for SOSensible.&lt;/p&gt;
	&lt;/div&gt;
	
	&lt;co:contentblock id="servantAdmin" skip="false"&gt;
		
		&lt;em&gt;The following content is requested via a servant oriented request. Rather than going over HTTP it is requested locally and displayed within the content. This is faster and scales better.&lt;/em&gt;
		&lt;appestry:appcall subapp="learn_admin" action="_appestry" /&gt;
		
	&lt;/co:contentblock&gt;
		</pre>
	</div>
</div>

<co:script id="lrnAdmTest">
// alert("This came from servant app call.");
</co:script>