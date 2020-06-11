#!/bin/bash

echo "Please enter a model name :"
read name

if [ -z $name ]
then
    printf "\e[31mError :No controller name entered\n\n\e[0m"
    exit
fi

# Make sure first letter is uppercase
first_char=${name:0:1}
if [[ $first_char == [a-z] ]]
then
    printf "\e[31mError :First character must be uppercase\n\n\e[0m"
    exit
fi

model_fname=$name
model_template="<?php\n\tnamespace Matheos\\App;\n\n\tclass $model_fname extends \\Matheos\\MicroMVC\Model {\n\n\t}"
echo "Creating model class...\n"
echo "$model_template" > $model_fname.php
mv $model_fname.php ../../App/models/