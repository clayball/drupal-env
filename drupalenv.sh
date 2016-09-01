#!/bin/bash

##############################################################################
# Notes
#
# Use sqlite database. This removes the complexities when using other DB's.
# - stored by default in sites/default/files/.ht.sqlite
#
##############################################################################

# Initiate DRUPALENV
source config/config.sh


##############################################################################
# Functions
usage() {
    printf %b "Usage: ./drupalenv [setup,remove,restart] VERSION\n"
    printf %b " Examples: \n"
    printf %b " ./drupalenv setup 7.50\n"
    printf %b " ./drupalenv restart 7.50\n\n"
    exit 0
}

setup() {
    printf %b "[*] setting up version ${VERSION}\n"
    #drush dl drupal-${VERSION}
    # Create the files directory and settings.php file
    cd drupal-${VERSION}
    mkdir sites/default/files
    chmod o+w sites/default/files
    cp sites/default/default.settings.php sites/default/settings.php
    chmod o+w sites/default/settings.php
    # Inform user to install via browser
    printf %b "[*] To complete installation point your browser to 127.0.0.1/${DRUPALENV_ROOT}/drupal-${VERSION} \n\n"
    printf %b "[*] When the installation is complete come back here and press any key.\n"
    printf %b "[*]  press any key: "
    read anykey
    # Finalize installation
    printf %b "[*] Finalizing installation ...\n"
    chmod o-w sites/default/settings.php
}

remove() {
    printf %b "[*] removing version ${VERSION}\n"
}

restart() {
    # Set up a few things
    printf %b "[*] restarting version ${VERSION}\n"
    cd drupal-${VERSION}
    DBFILE="sites/default/files/.ht.sqlite"

    # blow away (backup) the existing database if it exists
    # TODO: add as option or prompt for user input
    if [ -f "$DBFILE" ]
    then
        printf %b "[*] moving current .ht.sqlite database (appending .bak)\n"
        mv $DBFILE $DBFILE.bak
    else
        printf %b "[*] warning - sqlite database not found\n"
    fi
    if [ -f 'sites/default/settings.php' ]
    then
        rm sites/default/settings.php
    fi
    cp sites/default/default.settings.php sites/default/settings.php
    printf %b "[*] restart process: \t\t\t\t [COMPLETE]\n\n"
}


##############################################################################
# usage: drupalenv ACTION VERSION
# drupalenv [setup,remove,restart] 7.43
# TODO: validate

# Make sure we have the arguments we need.. otherwise display usage details.
if [ ! $1 ]
then
    usage
fi
if [ ! $2 ]
then
    usage
fi

ACTION=$1
VERSION=$2

printf %b "[*] performing ${ACTION} for version ${VERSION}\n"

cd $DRUPALENV_ROOT

if [ "$ACTION" = "setup" ]
then
    # call setup function
    setup
elif [ "$ACTION" = "remove" ]
then
    # call remove function
    remove
elif [ "$ACTION" = "restart" ]
then
    # call restart function
    restart
else
    printf %b "[-] No action to perform.\n"
fi



