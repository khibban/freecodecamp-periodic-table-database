#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

MAIN_MENU(){
    if [[ -z $1 ]]; then
        echo "Please provide an element as an argument."
        return
    fi

    if [[ $1 =~ ^[0-9]+$ ]]; then
        ELEMENT_CONDITION="atomic_number = $1"
    else
        if [[ $1 =~ ^[A-Z][a-z]?$ ]]; then
            ELEMENT_CONDITION="symbol = '$1'"
        else
            ELEMENT_CONDITION="name = '$1'"
        fi
    fi

    ELEMENT_DETAILS=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
                             FROM elements 
                             JOIN properties USING(atomic_number) 
                             JOIN types USING(type_id) 
                             WHERE $ELEMENT_CONDITION")

    if [[ -z $ELEMENT_DETAILS ]]; then
        echo "I could not find that element in the database."
        return
    fi

    IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< "$ELEMENT_DETAILS"

    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
}

MAIN_MENU "$1"
