#!/bin/bash

BLUE='\033[1;34m'
COLORF='\033[0m'
GREEN='\033[1;32m'
NEGRITO='\033[1m'
ORANGE='\033[1;33m'
RED='\033[1;31m'

credits(){
echo
echo -e "${NEGRITO}===============================================${COLORF}"
echo -e "${NEGRITO}Script developed by:${COLORF} ${BLUE}Eduardo Buzzi${COLORF}"
echo -e "${NEGRITO}More Scripts in:${COLORF} ${RED}https://github.com/eduardbuzzi${COLORF}"
echo -e "${NEGRITO}===============================================${COLORF}"
}

domain(){
read -p "DOMAIN => " DOMAIN
if [ -z "$DOMAIN" ]
then
domain
fi
VERIFICATION=$(host $DOMAIN | grep "found")
if [ ! -z "$VERIFICATION" ]
then
domain
fi
}

verification(){
REFUSED=$(host -t TXT $DOMAIN | grep "refused")
if [ ! -z "$REFUSED" ]
then
echo
echo -e "${NEGRITO}connection refused with $DOMAIN ;(${COLORF}"
echo "try mail spoofing manually and see what happens."
principal
fi
SPF1=$(host -t TXT $DOMAIN | grep "v=spf1" | cut -d '"' -f2 | grep -oE '[^ ]+$')
if [ "$SPF1" = "-all" ]
then
echo
echo -e "${GREEN}$DOMAIN is Not Vulnerable${COLORF}"
elif [ "$SPF1" = "~all" ]
then
echo
echo -e "${ORANGE}$DOMAIN is VULNERABLE (usually sent in the Spam box)${COLORF}"
elif [ "$SPF1" = "?all" ]
then
echo
echo  -e "${RED}$DOMAIN is VULNERABLE!!${COLORF}"
elif [ -z "$SPF1" ]
then
echo
echo -e "$DOMAIN is ${RED}TOTALLY VULNERABLE${COLORF} or ${GREEN}Not Vulnerable${COLORF}"
echo -e "Please, use: '${NEGRITO}host -t TXT $DOMAIN${COLORF}' to analyze correctly.."
else
echo
echo "I'm confused, I don't recognize that term."
fi
}

principal(){
echo
domain
verification
principal
}
credits
principal
