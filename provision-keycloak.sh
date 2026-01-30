#!/bin/bash

# Use the SERVICE NAME 'keycloak' because this script runs inside a container
KC_URL="http://keycloak:8080"

echo "Waiting for Keycloak to start on $KC_URL..."
until bash -c ":> /dev/tcp/keycloak/8080" 2>/dev/null; do
  echo "Keycloak not reachable yet... sleeping"
  sleep 2
done

echo "Keycloak is up! Provisioning..."

# 1. Login using the service name 'keycloak'
/opt/keycloak/bin/kcadm.sh config credentials \
  --server $KC_URL \
  --realm master \
  --user $KEYCLOAK_ADMIN \
  --password $KEYCLOAK_ADMIN_PASSWORD

# 2. Create the Realm (Check if it exists first to avoid errors)
/opt/keycloak/bin/kcadm.sh create realms -s realm=$KEYCLOAK_REALM -s enabled=true || echo "Realm might already exist"

# 3. Create Order Client
/opt/keycloak/bin/kcadm.sh create clients -r $KEYCLOAK_REALM \
  -s clientId=$ORDER_SERVICE_CLIENT_ID \
  -s enabled=true \
  -s clientAuthenticatorType=client-secret \
  -s secret=$ORDER_SERVICE_CLIENT_SECRET \
  -s serviceAccountsEnabled=true \
  -s "redirectUris=[\"*\"]"

# 4. Create Inventory Client
/opt/keycloak/bin/kcadm.sh create clients -r $KEYCLOAK_REALM \
  -s clientId=inventory-service-client \
  -s enabled=true \
  -s clientAuthenticatorType=client-secret \
  -s secret=$INVENTORY_SERVICE_CLIENT_SECRET \
  -s serviceAccountsEnabled=true \
  -s "redirectUris=[\"*\"]"

echo "Provisioning complete!"