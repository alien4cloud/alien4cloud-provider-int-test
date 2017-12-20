#!/bin/bash -e

directory=/var/www/html/vault/test
if [ ! -d "$directory" ]; then
  sudo mkdir -p $directory
fi
echo "------------------------ ENV ------------------------"
echo "Secret : $secret" | sudo tee $directory/secret.txt
echo "Secret property : $secret_property" | sudo tee $directory/secret_property.txt
echo "Secret attribute : $secret_attribute" | sudo tee $directory/secret_attribute.txt
echo "Secret output : $secret_output" | sudo tee $directory/secret_output.txt
echo "Secret input : $secret_input" | sudo tee $directory/secret_input.txt
echo "Complex input : $complex_input" | sudo tee $directory/complex_input.txt
echo "---------------------------- ------------------------"
export SECRET_OUTPUT=$secret_property
