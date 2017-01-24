<cfimport prefix="co" taglib="/share/tags/collaboration" />
<cfimport prefix="boot" taglib="/share/tags/collaboration/ext/bootstrap" />
      <!-- Main hero unit for a primary marketing message or call to action -->
	  
	<co:collaborate />
	  
	<div class="row">
	  <!---<div class="hero-unit">--->
	  <boot:hero>
	  	<img src="/apps/main/_app/media/dep_2790563-Laptop-with-Globe_expand.jpg" style="float:right;margin-left:10px;margin-bottom:6px;height:200px;border:2px solid black;" />
        <h1 style="margin-bottom:10px;">The <em>NEW</em> <img src="/_site/media/logo.png" alt="SOSensible" style="margin-top:-24px;"></h1>
        <p>Getting the right mix is always a challenge. The right mix is holding onto the enduring truths of those who have gone before while embracing the innovations and insights of those who come after. At SOSensible we are passionate about embracing and finding the right mix in an organic way that avoids a one size fits all mindset.</p>
        <p><a href="/apps/blog/?post=1000" class="btn btn-primary btn-large">Learn more &raquo;</a></p>
      </boot:hero>
	  <!---</div>--->
	</div>
	
	<!-- Example row of columns -->
	<div class="row">
		<div class="span4">
			<h2><a href="/apps/main/sites.cfm" style="text-decoration:none;">Web Sites</a></h2>
			<a href="/apps/main/sites.cfm"><img src="/apps/main/_app/media/dep_8022815-Office-website-template.jpg" style="float:left;margin-right:8px;margin-bottom:6px;height:80px;border:2px solid #285094;" /></a>
			<p>At SOSensible we have a history of intranet solutions to provide companies internal function as well as extranets for business to business.</p>
			<p><a class="btn" href="/apps/main/sites.cfm">View details &raquo;</a></p>
		</div>
		<div class="span4">
			<h2><a href="/apps/main/mobile.cfm" style="text-decoration:none;">Mobile</a></h2>
			<a href="/apps/main/mobile.cfm"><img src="/apps/main/_app/media/dep_13620465-Technology.jpg" style="float:left;margin-right:8px;margin-bottom:6px;height:80px;border:2px solid #285094;" /></a>
			<p>Mobile can come in three flavors. There is adaptable web sites that work well on mobile devices, web apps that can run offline and actual apps that are built to run on iOS or Android.</p>
			<p><a class="btn" href="/apps/main/mobile.cfm">View details &raquo;</a></p>
		</div>
		<div class="span4">
			<h2><a href="/apps/learn" style="text-decoration:none;">Training</a></h2>
			<a href="/apps/learn"><img src="/apps/main/_app/media/dep_9691748-Student-studying.jpg" style="float:left;margin-right:8px;margin-bottom:6px;height:80px;border:2px solid #285094;" /></a>
			<p>We have produced books, spoken at conferences and created online training courses.</p>
			<p><a class="btn" href="/apps/learn/">View details &raquo;</a></p>
		</div>
	</div>
	<!---
	<cfscript>
	user = EntityLoad('site__user');
	writeDump(user);
	</cfscript>
	--->
	