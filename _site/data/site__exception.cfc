component persistent="true" table="site__exception"  output="false" extends="share.objects.appestry.orm"
{
	/* properties */
	
	property name="exception_id" column="exception_id" type="numeric" ormtype="int" fieldtype="id" generated="insert" generator="native" ; 
	property name="created_on" column="created_on" type="date" ormtype="timestamp" ; 
	property name="user_id" column="user_id" type="numeric" ormtype="int" ; 
	property name="type" column="type" type="string" ormtype="string" ; 
	property name="message" column="message" type="string" ormtype="string" ; 
	property name="extendedInfo" column="extendedInfo" type="string" ormtype="string" ; 
	property name="detail" column="detail" type="string" ormtype="string" ; 
	property name="tagContext" column="tagContext" type="string" ormtype="string" ; 
	property name="app" column="app" type="string" ormtype="string" ; 
	property name="template" column="template" type="string" ormtype="string" ; 
	property name="refURL" column="refURL" type="string" ormtype="string" ; 
	property name="refIP" column="refIP" type="string" ormtype="string" ; 
	property name="hit" column="hit" type="numeric" ormtype="int" ; 
	property name="methodology" column="methodology" type="string" ormtype="string" ; 
	property name="line" column="line" type="numeric" ormtype="int" ; 	
} 
