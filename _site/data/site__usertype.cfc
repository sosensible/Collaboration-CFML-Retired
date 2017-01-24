<cfcomponent persistent="true" table="site__usertype"  output="false" extends="share.objects.appestry.orm">
	<!---- properties ---->
	
	<cfproperty name="usertype_id" column="usertype_id" type="numeric" ormtype="int" fieldtype="id" generated="insert" generator="native"  /> 
	<cfproperty name="usertype_main" column="usertype_main" type="string" ormtype="string"  /> 
	<cfproperty name="description" column="description" type="string" ormtype="string"  /> 	
</cfcomponent> 
