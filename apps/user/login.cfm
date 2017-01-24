<cfimport prefix="co" taglib="/share/tags/collaboration" />
	<!-- Example row of columns -->
	<div class="row">
		<img src="/apps/blog/_app/media/blog_logo_med.png" alt="About"  style="float:right;margin-bottom:6px;" />
		<h1>Login Page</h1>
		<p>Welcome to the user section of SOSensible.</p>
		<p>The current user is <co:text id="userName" />.</p>
		
		<co:a id="regLink">Register</co:a>
	</div>
	