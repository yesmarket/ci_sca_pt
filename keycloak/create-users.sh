#!/bin/bash

while ! curl http://keycloak:8080/auth
do
  sleep 10
done

/opt/jboss/keycloak/bin/kcadm.sh config credentials --server http://keycloak:8080/auth --realm master --user admin --password admin
/opt/jboss/keycloak/bin/kcadm.sh create users -s username=admin -s enabled=true -r galaxy
/opt/jboss/keycloak/bin/kcadm.sh update users/"$(/opt/jboss/keycloak/bin/kcadm.sh get users -r galaxy -q username=admin | jq '.[0].id' | sed 's/"//g')"/reset-password -r galaxy -s type=password -s value=admin -s temporary=false -n
