component persistent="true" table="site__site"  output="false" extends="share.objects.appestry.orm"
{
	/* properties */
	
	property name="site_id" column="site_id" type="numeric" ormtype="int" fieldtype="id" generated="insert" generator="native" ; 
	property name="site_main" column="site_main" type="string" ormtype="string" default="default" ; 
	property name="url" column="url" type="string" ormtype="string" default="" ; 
	property name="roles" column="roles" type="string" ormtype="string" default="" ; 
	property name="stage" column="stage" type="string" ormtype="string" default="build" ; 
	property name="created_on" column="created_on" type="date" ormtype="timestamp" ; 
	property name="updated_on" column="updated_on" type="date" ormtype="timestamp" ; 
	property name="title_seo" column="title_seo" type="string" ormtype="string" ; 
	property name="keywords_seo" column="keywords_seo" type="string" ormtype="string" ; 
	property name="description_seo" column="description_seo" type="string" ormtype="string" ; 
	property name="isdeleted" column="isdeleted" type="numeric" ormtype="byte" ;
	
	/* Relational Properties */
	
	//extra properties
	
	/* Over Ride Functions */
	
} 
