<cfsetting enablecfoutputonly="yes">
<cfif thisTag.executionMode EQ "start">
</cfif><cfsetting enablecfoutputonly="no"><cfif thisTag.executionMode EQ "end"><cfoutput><a class="btn btn-primary btn-large" data-toggle="modal" href="##beta#ATTRIBUTES.name#">Join the #ATTRIBUTES.name# Beta</a> 
<div id="beta#ATTRIBUTES.name#" class="modal hide fade">
    <div class="modal-header">
            <button class="close" data-dismiss="modal">x</button>
            <h3>Request #ATTRIBUTES.name# Beta Access</h3>
    </div>
	<div class="modal-body">
		<div class="row-fluid">
			<div class="span12">
				<div class="span6">
				<div class="logowrapper">
					<img class="logoicon" src="http://placehold.it/300x300/bbb/&text=Your%20Logo" alt="App Logo"/>
				</div>
				</div>
				<div class="span6">
					<form class="form-horizontal" action="#ATTRIBUTES.target#">
						<p class="help-block">Name</p>
						<div class="input-prepend">
							<span class="add-on">*</span><input class="prependedInput" size="16" type="text">
						</div>
						<p class="help-block">Email</p>
						<div class="input-prepend">
							<span class="add-on">@</span><input class="prependedInput" size="16" type="email">
						</div>
						<hr>
						<div class="help-block">
							<input type="hidden" name="betaName" value="#ATTRIBUTES.name#" />
							<button type="submit" class="btn btn-large btn-info">Request an Invite</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
    <div class="modal-footer" style="text-align:left;">
        <p><i>#ATTRIBUTES.note#</i></p>
    </div>
</div></cfoutput><cfset thisTag.generatedContent=""></cfif>