<cfimport prefix="co" taglib="/share/tags/collaboration" />

<co:collaborate>

	<!-- Example row of columns -->
	<div class="row">
		<h1>Staff</h1>
		<img src="/apps/main/_app/media/JohnFarrar.png" style="float:right;border:2px solid black;margin-left:10px;margin-bottom:5px;" />
		<h2>John Farrar</h2>
		<p>This is the page about John Farrar, the CEO of SOSensible.</p>
		<co:contentblock id="myContent" skip="false">
		<co:a id="myLink" href="/">Home</co:a><br />
		<co:button id="myButton">Button Text</co:button><br />
		<co:checkbox id="myCheckBox" value="Verify" /><br />
		<co:checkboxlist id="myCBList" data="one,two,three" selected="two,three" orientation="horizontal" /><br />
		</co:contentblock>
		
		<co:select id="mySelect" data="red,green,blue,purple,orange" selected="purple" />
		<co:selectList id="mySelectList" data="red,green,blue,purple,orange" selected="purple" />
		<co:list id="myList" data="red,green,blue" />
		
	</div>
</co:collaborate>

<!---
<span class='st_sharethis_large' displayText='ShareThis'></span>
<span class='st_facebook_large' displayText='Facebook'></span>
<span class='st_twitter_large' displayText='Tweet'></span>
<span class='st_linkedin_large' displayText='LinkedIn'></span>
<span class='st_wordpress_large' displayText='WordPress'></span>
<span class='st_googleplus_large' displayText='Google +'></span>
<span class='st_pinterest_large' displayText='Pinterest'></span>
<span class='st_delicious_large' displayText='Delicious'></span>
<span class='st_email_large' displayText='Email'></span>
<co:script id="shareThisSize">var switchTo5x=true;</co:script>
<co:script id="shareThisBTN" src="http://w.sharethis.com/button/buttons.js" />
<co:script id="shareThisID">stLight.options({publisher: "46993155-f6d3-4aaf-8b9f-1e19d5c3edbb", doNotHash: false, doNotCopy: false, hashAddressBar: false});</co:script>
<cfdump var="#REQUEST._content#"/>
--->

<cfoutput>
#REQUEST._content.getHeadCSSContent()#

#REQUEST._content.getHeadJSContent()#
</cfoutput>