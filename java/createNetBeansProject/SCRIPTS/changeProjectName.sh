#!/bin/bash

#### Changes the project name and folder of a NetBeans project to a new name

### Args: $1 : the path to the netbeans project you want to change the name
###   	  $2 : the new name

PROJECT_DIR=$1
NEW_NAME=$2
 
if [ -z "$1" ] && [ -z "$2" ]; then
	echo -n "Enter project dir (must be in this folder):  "
	read -r PROJECT_DIR
	echo -n "Enter new project name:  "
	read -r NEW_NAME
fi



sed -i "s/$PROJECT_DIR/$NEW_NAME/g" "$PROJECT_DIR/build.xml"
sed -i "s/$PROJECT_DIR/$NEW_NAME/g" "$PROJECT_DIR/web/META-INF/context.xml"
sed -i "s/$PROJECT_DIR/$NEW_NAME/g" "$PROJECT_DIR/nbproject/project.xml"
sed -i "s/$PROJECT_DIR/$NEW_NAME/g" "$PROJECT_DIR/nbproject/project.properties"
sed -i "s/$PROJECT_DIR/$NEW_NAME/g" "$PROJECT_DIR/nbproject/build-impl.xml"

## Rename directory as well
mv $PROJECT_DIR $NEW_NAME
