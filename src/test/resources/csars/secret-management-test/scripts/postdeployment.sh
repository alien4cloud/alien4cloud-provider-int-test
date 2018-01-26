#!/bin/bash

directory=/var/www/html/vault/test
if [ ! -d "$directory" ]; then
  sudo mkdir -p $directory
fi

echo "------------------------ENV--------------------------"
echo "Secret property : $self_property_secret_prop" | sudo tee $directory/self_property_secret_prop.txt
echo "Secret attribute : $self_attribute_secret_att" | sudo tee $directory/self_attribute_secret_att.txt
echo "-----------------------------------------------------"
