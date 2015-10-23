#!/bin/bash

###
### Script that creates an entity class and generates 3 constructors and all getters and setters
### for quick use at our exam 
###

## index of arrays
ac=1

echo
echo "****************************"
echo "*** Entity class creator ***"
echo "****************************"
echo

echo -n "Enter entity class name: "
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

attributeNames[1]="first"
attributeNames[2]="second"
attributeNames[3]="age"
attributeTypes[1]="String"
attributeTypes[2]="String"
attributeTypes[3]="int"


#### info is collected do some WORK 
############################################################


file="scriptResults/$CLASSNAME.java"

## replace all CLASSNAME_ with the user provided class name
sed "s/CLASSNAME_/$CLASSNAME/g" CLASS_TEMPLATE > $file

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
echo $text;
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


echo
echo
echo "Entity class created in $file"
echo "...REMEMBER to add your persistence unit seperately!..."
echo




