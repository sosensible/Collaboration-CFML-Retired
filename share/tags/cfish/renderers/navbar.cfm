<cfimport prefix="cfish" taglib="/share/tags/cfish/"><cfif ATTRIBUTES.mode EQ "render">
<div class="navbar">
	<div class="navbar-inner">
</cfif>
<cfoutput>#REQUEST._content.getBlockContent(name:ATTRIBUTES.name)##thisTag.generatedContent#</cfoutput><cfif ATTRIBUTES.mode EQ "render">
	</div>
</div></cfif>
<!---
asdf<cfabort>

/* Type of navbar components that need tags */
// Brand
<a class="brand" href="#">Project name</a>

// Nav Links ( # handle for vertical dividers on horizontal navbars )
<ul class="nav">
  <li class="active">
    <a href="#">Home</a>
  </li>
  <li class="divider-vertical"></li>
  <li><a href="#">Link</a></li>
  <li><a href="#">Link</a></li>
  ...
</ul>


// Forms
<form class="navbar-form pull-left">
  <input type="text" class="span2">
  <button type="submit" class="btn">Submit</button>
</form>

// Search Form
<form class="navbar-search pull-left">
  <input type="text" class="search-query" placeholder="Search">
</form>

// + handle
// . alignment ( .pull-left, .pull-right )
// . using dropdowns
// . text ( usually wrapped in <p> )
// . fixed to top ( class="navbar navbar-fixed-top", typically need to add 40px padding to top of body )
// . fixed to bottom ( class="navbar navbar-fixed-bottom" )
// . static top navbar ( class="navbar navbar-static-top", no padding needed and scrolls away )
// . responsive navbar ( see docs, # requires collapse plugin and responsive CSS file )
// . navbar-inverse

--->