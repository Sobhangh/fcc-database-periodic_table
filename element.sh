#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ $# -eq 0 ]]
then
  echo Please provide an element as an argument.
else
  RESULT=$($PSQL "SELECT * FROM elements WHERE atomic_number=$1")
  if [[ -z $RESULT ]]
  then 
    RESULT=$($PSQL "SELECT * FROM elements WHERE symbol='$1'")
    if [[ -z $RESULT ]]
    then
      RESULT=$($PSQL "SELECT * FROM elements WHERE name='$1'")
      if [[ -z $RESULT ]]
      then
        echo I could not find that element in the database.
        exit
      fi
    fi
  fi
  echo $RESULT
  IFS='|' read -r at_nb symb name <<< "$RESULT"
  RESULT=$($PSQL "SELECT * FROM properties WHERE atomic_number=$at_nb")
  IFS='|' read -r at_nb2 at_mas melt boil type_id <<< "$RESULT"
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$type_id")
  echo "The element with the atomic number $at_nb is $name ($symb). It's a $TYPE, with a mass of $at_mass. $name has a melting point of $melt celsius and a boiling point of $boil celsius."
fi