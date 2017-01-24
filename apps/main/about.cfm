<cfimport prefix="co" taglib="/share/tags/collaboration" />
	<!-- Example row of columns -->
	<div class="row">
		<img src="/apps/main/_app/media/dep_2618303-Business-Agreement.jpg" alt="About"  style="float:right;margin-bottom:6px;height:240px;" />
		<h1>About</h1>
		<p>This is the page where you learn about SOSensible.</p>
		<p>( <a href="/apps/main/staff.cfm?name=John Farrar">For information about our CEO.</a> )</p>
	</div>
<pre>
SET: @SITE@, @APP@, @SUBAPP@ / @SUBAPP:media@<br>
&lt;co:img src="@APP@myImg.png" /><br>
&lt;co:img appsrc="myImg.png" /><br>
<em>NOTE: the default for different tags will change. Img of course would target the media folder.</em>
</pre>