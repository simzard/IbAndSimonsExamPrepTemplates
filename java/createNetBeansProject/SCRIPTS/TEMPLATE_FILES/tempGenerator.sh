#!/bin/bash

### Generator .sh template for getting the sed's right


pattern="Persistence;"
import="ENTITY IMPORT;\nFACADE IMPORT"
sed "/$pattern/a ${import}" "GENERATOR_TEMPLATE.java" > tmpGenerator.java

pattern="RandomString();"
sp="\ \ \ \ \ \ \ \ "
facade="${sp}Here's a NEW FACADE LINE!"
sed -i "/$pattern/a ${facade}" "tmpGenerator.java" 


pattern="i++) {"
sp="\ \ \ \ \ \ \ \ \ \ \ \ "
obj="${sp}HERE A NEW OBJECT WILL GET CREATED"
facade="${obj}\n${sp}Here's a NEW LINE!"
sed -i "/$pattern/a ${facade}" "tmpGenerator.java" 
