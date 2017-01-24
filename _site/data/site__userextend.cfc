component persistent="true" table="site__userextend"  output="false" extends="share.objects.appestry.orm"
{
	/* properties */
	
	property name="userextend_id" column="userextend_id" type="numeric" ormtype="int" fieldtype="id" generated="insert" generator="native" ; 
	property name="user_id" column="user_id" type="numeric" ormtype="int" insert="false" update="false" ; 
	property name="showdetail" column="showdetail" type="numeric" ormtype="byte" default="1" ; 
	property name="securityquestion" column="securityquestion" type="string" ormtype="string" default="" ; 
	property name="securityanswer" column="securityanswer" type="string" ormtype="string" default="" ; 
	property name="img" column="img" type="string" ormtype="string" default="" ; 
	property name="thumb" column="thumb" type="string" ormtype="string" default="" ;
	property name="education" column="education" type="string" ormtype="string" default="" ;
	property name="hometown" column="hometown" type="string" ormtype="string" default="" ;
	property name="phone" column="phone" type="string" ormtype="string" default="" ;
	property name="employer" column="employer" type="string" ormtype="string" default="" ;
	property name="hobbies" column="hobbies" type="string" ormtype="string" default="" ;
	property name="editor" column="editor" type="numeric" ormtype="byte" default="" ;
	property name="active" column="active" type="numeric" ormtype="byte" default="1" ; 
	
	/* Relational Properties */
	property name="site__user" fieldtype="one-to-one" 
		cfc="site__user" fkcolumn="user_id" ;
} 
