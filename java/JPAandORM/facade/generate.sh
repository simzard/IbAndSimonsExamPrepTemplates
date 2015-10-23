#!/bin/bash

lowercase=${1,,}
sed "s/ENTITY_/$1/g" ENTITY_Facade.java > "scriptResults/$1Facade.java"
sed -i "s/entity_/$lowercase/g" "scriptResults/$1Facade.java"

echo
echo "...Produced scriptResults/$1Facade.java"
echo "...now REMEMBER to edit the update lines in the method:"
echo "----> public $1 edit$1() { ... } accordingly!..."
echo
echo "...they are between the markers with the text:  ///// MUST EDIT THESE!"

