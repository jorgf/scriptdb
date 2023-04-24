#!/bin/bash
#./importSQL.sh -- AUTOMATING DATABASE IMPORTS
# AUTHOR: Jorge França
# ------------------------------------------------------------------
# IMPORTANT: SCRIPT DESIGNED ONLY TO WORK WITH POSTGRESQL
# --
# TODO:
# 1. DO IMPORTS TO OTHER DATABASES - possibly using configuration files
# 2. ADD MODULE TO DUMP THE DATABASE, SO THE SCRIPT WOULD BE COMPLETE: DUMP AND IMPORT THE DUMP
# ------------------------------------------------------------------

################ CONFIG 
HOST=""                       # "localhost" if local database   
USER=""                       # Database user
DATABASE=""                   # Database to be created and used to import the dumps
PASSWORD=""                   # Database password
PORT=""                       # Database port
PATH_FILE="dump/"             # dir with dump files
DEBUG="0"                     # 0=off, 1=on
COLOR="1"                     # 0=off, 1=on

################ FUNCTIONS
msg_color(){
  if [ "$COLOR" -eq "1" ]; then
    printf '%b\n' "\e[44;1m$*\e[m"
  else
    printf '%s\n' "$*"
  fi
}

msg_error(){
  if [ "$COLOR" -eq "1" ]; then
    printf '%b\n' "\e[31;1m$*\e[m"
  else
    printf '%s\n' "$*"
  fi
}

debug(){
  if [ "$DEBUG" -eq "1" ]; then
    set -xv
  fi
}

banner_import(){
  echo " "
  msg_color "====== IMPORT TO DATABASE ======"
  echo "processos: "
}

# This function is only valid when the database is in a < Homestead > machine
# and you try to access database through the host.
# if this is not your case, please define the port number in the PORT variable.
definePort(){
  SYSTEMV=`sudo dmidecode -t 1 | grep "Family" | cut -d ":" -f2`
  if [[ "$SYSTEMV" == " Virtual Machine" ]]; then
    echo "--> Running in homestead!"
	  PORT="5432"
  else
    echo "--> Running in host!"
	  PORT="54320"
  fi
}

createdb(){
	if [ -n "$DATABASE" ]; then
    SCRIPT="CREATE DATABASE ${DATABASE}"
    PGPASSWORD="$PASSWORD" psql -U "$USER" -h "$HOST" -p "$PORT" -c "$SCRIPT"
    if [ "$?" -eq "2" ]; then
      msg_error "ERROR!"
      exit
    fi
    msg_color "--> Import to database: <$DATABASE>"
    return 0
  else
    msg_error "ERROR! Define database name!"
		return 1
  fi
}

################ START
debug
banner_import
if [ -z "$PORT" ]; then 
  definePort 
fi
createdb
if [[ "$?" -eq "0"  ]]; then
  msg_color "--> Reading file in 'dump/' dir"
  FILES=`ls $PATH_FILE*.sql`
  sleep 2
  for FILE in $FILES
  do
    PGPASSWORD="$PASSWORD" psql -U "$USER" -h "$HOST" -p "$PORT" "$DATABASE" < "$FILE"
	done
else
	msg_error "ERROR! could not import data!"
  exit
fi