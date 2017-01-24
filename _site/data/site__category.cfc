component persistent="true" table="site__category"  output="false" extends="share.objects.appestry.orm"
{
	/* properties */
	
	property name="category_id" column="category_id" type="numeric" ormtype="int" fieldtype="id" generated="insert" generator="native" ; 
	property name="category_main" column="category_main" type="string" ormtype="string" ; 
	property name="description" column="description" type="string" ormtype="string" ; 
	property name="title_seo" column="title_seo" type="string" ormtype="string" ; 
	property name="keywords_seo" column="keywords_seo" type="string" ormtype="string" ; 
	property name="description_seo" column="description_seo" type="string" ormtype="string" ; 
	property name="parent_tree" column="parent_tree" type="numeric" ormtype="int" ; 
	property name="left_tree" column="left_tree" type="numeric" ormtype="int" ; 
	property name="right_tree" column="right_tree" type="numeric" ormtype="int" ; 	
} 
