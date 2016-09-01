#!/bin/bash

# Initiate DRUPALENV
source config/config.sh

# usage: drupalenv ACTION VERSION
# drupalenv [setup,remove,restart] 7.43
# TODO: validate
ACTION=$1
VERSION=$2

printf %b "[*] performing ${ACTION} for version ${VERSION}\n"

cd $DRUPALENV_ROOT

if [ "$ACTION" = "setup" ]
then
    printf %b "[*] setting up version ${VERSION}\n"
    drush dl drupal-${VERSION}
elif [ "$ACTION" = "remove" ]
then
    printf %b "[*] removing version ${VERSION}\n"
else
    printf %b "[-] No action to perform.\n"
fi


