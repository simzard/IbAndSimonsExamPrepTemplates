#!/bin/bash

###
### Script that creates an entity class and generates 3 constructors and all getters and setters
### for quick use at our exam 
###

## index of arrays


TEMPLATE_DIR="TEMPLATE_FILES"

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
	
	
	file="generatedClasses/$CLASSNAME.java"
	
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
		
done
	
	
echo	
echo "..."
echo "..."
echo "Entity class(es) created..."
	
	
	


