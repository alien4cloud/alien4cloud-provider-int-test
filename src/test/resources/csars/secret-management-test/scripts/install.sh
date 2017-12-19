#!/bin/bash

echo "------------------------ ENV ------------------------"
echo "Secret : $secret"
echo "Secret property : $secret_property"
echo "Secret attribute : $secret_attribute"
echo "Secret output : $secret_output"
echo "Secret input : $secret_input"
echo "Complex input : $complex_input"
echo "---------------------------- ------------------------"
export SECRET_OUTPUT=$secret_property
