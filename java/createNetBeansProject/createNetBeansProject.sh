#!/bin/bash

#### Creates a complete JAVA WEB PROJECT provided a directory name from the user
#### Run it with one arg for ProjectName or without and the script will ask for it.

SCRIPT_FOLDER="SCRIPTS"

CREATE_FOLDER="$HOME/NetBeansProjects/SCRIPT_GENERATED/"

mkdir -p $CREATE_FOLDER

TEMPLATE_NAME="TEMPLATE_JAVA_WEB_PROJECT"
TEMPLATE_NAME_FOLDER="$SCRIPT_FOLDER/TEMPLATE_JAVA_WEB_PROJECT"

GENERATED_CLASSES_FOLDER="$SCRIPT_FOLDER/TEMP_GENERATED_CLASSES"

TEMPLATE_FILES_FOLDER="${SCRIPT_FOLDER}/TEMPLATE_FILES"


PROJECT_NAME=$1

if [ -z "$1" ]; then

	echo
	echo
	echo "********************************************"
	echo "*         NETBEANS Project Creator         *"
	echo "********************************************"
	echo
	echo 
	echo -n "Enter name of project(i.e. folder name):  "
	read -r PROJECT_NAME

fi

### Generate the project's database from scratch
### This assumes the root password is empty
DATABASE_NAME=${PROJECT_NAME}_DB
echo "DROP DATABASE IF EXISTS $DATABASE_NAME" | mysql -u root
echo "CREATE DATABASE IF NOT EXISTS $DATABASE_NAME" | mysql -u root
echo "...MySQL Database created..."

NEW_PROJECT_DIR="${CREATE_FOLDER}${PROJECT_NAME}"

## Create the project dir (overwrite if it already exists)
rm -r $NEW_PROJECT_DIR &> /dev/null; mkdir $NEW_PROJECT_DIR

## Now copy all the template files to the new project
cp -r $TEMPLATE_NAME_FOLDER/* $NEW_PROJECT_DIR

### Now replace all template names with the new name provided
### in all the .xml files (following NetBeans rules)
sed -i "s/$TEMPLATE_NAME/$PROJECT_NAME/g" "$NEW_PROJECT_DIR/build.xml"
sed -i "s/$TEMPLATE_NAME/$PROJECT_NAME/g" "$NEW_PROJECT_DIR/web/META-INF/context.xml"
sed -i "s/$TEMPLATE_NAME/$PROJECT_NAME/g" "$NEW_PROJECT_DIR/nbproject/project.xml"
sed -i "s/$TEMPLATE_NAME/$PROJECT_NAME/g" "$NEW_PROJECT_DIR/nbproject/project.properties"
sed -i "s/$TEMPLATE_NAME/$PROJECT_NAME/g" "$NEW_PROJECT_DIR/nbproject/build-impl.xml"

##### persistence.xml

### Now copy the persistence.xml template to the new project
cp SCRIPTS/TEMPLATE_FILES/PERSISTENCE_XML_TEMPLATE "$NEW_PROJECT_DIR/src/conf/persistence.xml"

### Now update the persistence.xml with the right project name
sed -i "s/$TEMPLATE_NAME/$PROJECT_NAME/g" "$NEW_PROJECT_DIR/src/conf/persistence.xml"

### Now update the persistence.xml with the right database
sed -i "s/DATABASE_NAME/$DATABASE_NAME/g" "$NEW_PROJECT_DIR/src/conf/persistence.xml"

##### Tester template

mkdir -p $NEW_PROJECT_DIR/src/java/test
mkdir -p $NEW_PROJECT_DIR/web/WEB-INF

cp SCRIPTS/TEMPLATE_FILES/TESTER_TEMPLATE "$NEW_PROJECT_DIR/src/java/test/Tester.java"

cp "$TEMPLATE_FILES_FOLDER/GENERATOR_TEMPLATE" "$GENERATED_CLASSES_FOLDER/generators/Generator.java"

### Now generate entity classes with facades 
$SCRIPT_FOLDER/generateEntityClassWithFacadeAndPersistence.sh "$NEW_PROJECT_DIR"


### Temporary results are placed in generatedClasses - copy them - and delete them
mkdir $NEW_PROJECT_DIR/src/java/entities
cp $GENERATED_CLASSES_FOLDER/entities/*.java $NEW_PROJECT_DIR/src/java/entities
rm $GENERATED_CLASSES_FOLDER/entities/*.java

mkdir $NEW_PROJECT_DIR/src/java/facades
cp $GENERATED_CLASSES_FOLDER/facades/*.java $NEW_PROJECT_DIR/src/java/facades
rm $GENERATED_CLASSES_FOLDER/facades/*.java

mkdir $NEW_PROJECT_DIR/src/java/generators
cp $GENERATED_CLASSES_FOLDER/generators/*.java $NEW_PROJECT_DIR/src/java/generators
rm $GENERATED_CLASSES_FOLDER/generators/*.java

echo ...
echo ...
echo ...
echo ... "New project $PROJECT_NAME created in $NEW_PROJECT_DIR"

