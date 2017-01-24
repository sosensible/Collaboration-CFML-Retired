<cfimport prefix="cfish" taglib="/share/tags/cfish/"><cfparam name="request.__bodyContent" default=""><cfcontent reset="yes" /><!DOCTYPE html>
<html lang="en">
<head><cfoutput>
    <meta charset="utf-8">
    <title>SOSensible</title>
	<LINK REL="SHORTCUT ICON" HREF="/_site/media/favicon.ico">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
	
    <!-- Le styles -->
    <link href="/share/skin/#request._skin.get_name()#/bootstrap.css" rel="stylesheet">
    <style type="text/css" media="(min-width:980px)">
      body {
        padding-top: 60px;
        padding-bottom: 40px;
      }
    </style>
    <link href="/share/skin/#request._skin.get_name()#/bootstrap-responsive.css" rel="stylesheet">

    <!--Le HTML5 shim, for IE6-8 support of HTML5 elements-->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

    <!-- Le fav and touch icons -->
    <link rel="shortcut icon" href="/_site/media/ico/favicon.ico">
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="/_site/media/ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="/site/media/ico/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="/site/media/ico/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" href="/site/media/ico/apple-touch-icon-57-precomposed.png">
    <link href="#REQUEST._skin.get_CSSPath()#style.css" rel="stylesheet" type="text/css">

</cfoutput></head>

		  <cfish:block name="navright" mode="param">
			<div class="nav-collapse">
				<form class="navbar-search pull-right">
					<input type="text" class="search-query" placeholder="Search" />
				</form>
			</div>
		  </cfish:block>
		  
<body>
	
	<cfish:block name="sitebar" mode="render"></cfish:block>
		
    <div class="container">
	<cfish:block name="breadcrumbs" mode="render"></cfish:block>
<cfoutput>#request.__bodyContent#</cfoutput>
    </div>

	<hr>

	<footer class="container">
		<cfish:block name="footer" mode="render" />
	</footer>

    <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="/share/js/jquery/jquery.min.js"></script>
    <script src="/share/bootstrap/js/bootstrap.min.js"></script>
	<cfoutput>
	#REQUEST._content.getHeadCSSContent()#
	#REQUEST._content.getHeadJSContent()#
	</cfoutput>
	
</body>
</html>