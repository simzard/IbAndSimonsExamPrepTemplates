#!/bin/bash

###
### Script that creates an entity class and generates 3 constructors and all getters and setters 
### including facades for the entity classes
### for quick use at our exam 
###

### param is passed from createNetBeansProject.sh
NEW_PROJECT_DIR=$1
PROJECT_NAME=$(basename $NEW_PROJECT_DIR)


GENERATE_FOLDER="SCRIPTS/TEMP_GENERATED_CLASSES"

TEMPLATE_DIR="SCRIPTS/TEMPLATE_FILES"

echo
echo "****************************"
echo "*** Entity class creator ***"
echo "****************************"
echo

echo -n "Enter number of entity classes to create:  "
read -r CNUMBER

for (( j=1; j<=$CNUMBER; j++ ))
do
	ac=1
	## empty variables
	t1=""
	t2=""
	t3=""
	text=""


	echo -n "Enter entity class name $j / $CNUMBER: "
	read -r CLASSNAME

	## Get number of attributes to add to object
	echo
	echo -n "How many attributes in $CLASSNAME?  "
	read -r NUMBER


	for (( i=1; i<=$NUMBER; i++ ))
	do
		echo "--- Attribute number $i ---"
		echo -n "Enter attribute name:  "
		read -r attributeNames[ac]
		echo -n "Enter attribute type:  "
		read -r attributeTypes[ac++]
		echo
	done

	#### info is collected do some WORK 
	############################################################
	
	
	file="$GENERATE_FOLDER/entities/$CLASSNAME.java"
	
	## replace all CLASSNAME_ with the user provided class name
	sed "s/CLASSNAME_/$CLASSNAME/g" "$TEMPLATE_DIR/CLASS_TEMPLATE" > $file
	
	k=16
	
	#### insert setters
	for (( i=$NUMBER; i>=1; i-- ))
	do
		attributeType=${attributeTypes[$i]}
		attributeName=${attributeNames[$i]}
		upper=${attributeName^}
		t1="\ \ \ \ public void set$upper($attributeType $attributeName) {\n"
		t2="\ \ \ \ \ \ \ \ this.$attributeName = $attributeName;\n"
		t3="\ \ \ \ }\n"
		text=$t1$t2$t3
		
		sed -i "${k} i ${text}" $file
		
	done
	
	
	#### insert getters 
	for (( i=$NUMBER; i>=1; i-- ))
	do
		attributeType=${attributeTypes[$i]}
		attributeName=${attributeNames[$i]}
		upper=${attributeName^}
		t1="\ \ \ \ public $attributeType get$upper() {\n"
		t2="\ \ \ \ \ \ \ \ return $attributeName;\n"
		t3="\ \ \ \ }\n"
		text=$t1$t2$t3
		sed -i "${k} i ${text}" $file
	
	done
	
	#### insert 3 constructors: empty, full and full except id
	
	#### With Id
	t1="\ \ \ \ public $CLASSNAME(Integer id, "
	for (( i=1; i <= $NUMBER; i++ )) 
	do
		t1="$t1${attributeTypes[$i]} ${attributeNames[$i]}, "
	done
	
	t1="${t1::-2}) {\n"
	
	t2="\ \ \ \ \ \ \ \ this.id = id;\n"
	
	for (( i=1; i <= $NUMBER; i++ ))
	do
		t2="${t2}\ \ \ \ \ \ \ \ this.${attributeNames[$i]} = ${attributeNames[$i]};\n"
	done
	t2="${t2}\ \ \ \ }\n"
	text=$t1$t2
	
	sed -i "${k} i ${text}" $file
	
	#### Full except Id
	t2=""
	t1="\ \ \ \ public $CLASSNAME("
	for (( i=1; i <= $NUMBER; i++ )) 
	do
		t1="$t1${attributeTypes[$i]} ${attributeNames[$i]}, "
	done
	
	t1="${t1::-2}) {\n"
	
	for (( i=1; i <= $NUMBER; i++ ))
	do
		t2="${t2}\ \ \ \ \ \ \ \ this.${attributeNames[$i]} = ${attributeNames[$i]};\n"
	done
	t2="${t2}\ \ \ \ }\n"
	text=$t1$t2
	sed -i "${k} i ${text}" $file
	
	#### Empty constructor
	text="\ \ \ \ public $CLASSNAME() {\n\ \ \ \ }\n"
	sed -i "${k} i ${text}" $file
	
	#### insert attributes
	for (( i=$NUMBER; i>=1; i-- ))
	do
		attributeType=${attributeTypes[$i]}
		attributeName=${attributeNames[$i]}
		text="\ \ \ \ private $attributeType $attributeName;"
		sed -i "$((k-1)) i ${text}" $file
	done
	

	facadeFile="$GENERATE_FOLDER/facades/${CLASSNAME}Facade.java"
	lowercase=${CLASSNAME,,}

	sed "s/ENTITY_/$CLASSNAME/g" "$TEMPLATE_DIR/ENTITY_FACADE_TEMPLATE" > $facadeFile
	sed -i "s/entity_/$lowercase/g" $facadeFile

	
	### insert the overwrite lines in edit method
	for (( i=1; i<=$NUMBER; i++ ))
	do
		
		attributeType=${attributeTypes[$i]}
		attributeName=${attributeNames[$i]}
		
		theLine="\ \ \ \ \ \ \ \ \ \ \ \ ${lowercase}ToEdit.set${attributeName^}(x.get${attributeName^}());"
		thePattern="copy and persist"
		sed -i "/$thePattern/a ${theLine}" $facadeFile 

	done


	### Add the entity class to the persistence.xml
	XML_LINE="\ \ \ \ <class>entities.$CLASSNAME</class>"
	sed -i "5 i ${XML_LINE}" "$NEW_PROJECT_DIR/src/conf/persistence.xml"


	##### Tester class
	# import entities.Wood;
	# import facades.WoodFacade;
	# ...
	# WoodFacade facade = new WoodFacade(Persistence.createEntityManagerFactory("DoorsPU"));
	IMPORT_ENTITY="import entities.${CLASSNAME};"
	IMPORT_FACADE="import facades.${CLASSNAME}Facade;"
	sed -i "2 i ${IMPORT_FACADE}" "$NEW_PROJECT_DIR/src/java/test/Tester.java"
	sed -i "2 i ${IMPORT_ENTITY}" "$NEW_PROJECT_DIR/src/java/test/Tester.java"

	TYPE_NAME="${CLASSNAME}Facade"
	
	FACTORY_LINE="\ \ \ \ \ \ \ \ ${TYPE_NAME} ${CLASSNAME,,}Facade = new ${TYPE_NAME}(Persistence.createEntityManagerFactory(\"${PROJECT_NAME}PU\"));"

	pattern="test() {"
	sed -i "/$pattern/a ${FACTORY_LINE}" "$NEW_PROJECT_DIR/src/java/test/Tester.java"
	
	### generator
	
	pattern="Persistence;"
	IMPORT_ENTITY="import entities.${CLASSNAME};"
	IMPORT_FACADE="import facades.${CLASSNAME}Facade;"
	import="${IMPORT_ENTITY}\\n${IMPORT_FACADE}"
	sed -i "/$pattern/a ${import}" "$GENERATE_FOLDER/generators/Generator.java"

	pattern="RandomString();"
	sp="\ \ \ \ \ \ \ \ "
	# PersonFacade personFacade = new PersonFacade(Persistence.createEntityManagerFactory...
	FACTORY_LINE="${TYPE_NAME} ${CLASSNAME,,}Facade = new ${TYPE_NAME}(Persistence.createEntityManagerFactory(\"${PROJECT_NAME}PU\"));"
	facade="${sp}${FACTORY_LINE}"
	sed -i "/$pattern/a ${facade}" "$GENERATE_FOLDER/generators/Generator.java"

	sp="\ \ \ \ \ \ \ \ \ \ \ \ "
	lower="${CLASSNAME,,}"
	#Person person = new Person(...);
	theLine="${sp}${CLASSNAME} ${lower} = new ${CLASSNAME}("
	
	for (( i=1; i<=$NUMBER; i++ ))
	do
		
		attributeType=${attributeTypes[$i]}
		attributeName=${attributeNames[$i]}
		
		theLine="${theLine}\"${attributeName}_\"+rs.nextString(), "
		
	done	
	
	# now theLine contains a ', ' too much remove it
	theLine=${theLine::-2}
	theLine="${theLine});"
	
	the2ndLine="${sp}${lower}Facade.create${CLASSNAME}(${lower});"
	both="$theLine\\n${the2ndLine}"
	thePattern="i++) {"
	sed -i "/$thePattern/a ${both}" "$GENERATE_FOLDER/generators/Generator.java"
	


done
	
	
echo	
echo "..."
echo "..."
echo "Entity class(es) with facade(s) created..."
	
	
	


