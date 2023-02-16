#!/bin/zsh

source ~/.config/op/plugins.sh

vault auth enable jwt

##

vault write auth/jwt/config \
    oidc_discovery_url="https://oidc.circleci.com/org/a9a5631c-4b4a-4e52-a88b-01eb67119c6e" \
    bound_issuer="https://oidc.circleci.com/org/a9a5631c-4b4a-4e52-a88b-01eb67119c6e" 

##

curl --header "X-Vault-Token: $VAULT_TOKEN" "$VAULT_ADDR/v1/auth/jwt/config" | jq

##

vault policy write circleci-policy - <<EOF
# Grant CircleCI project <your project name> RO access to secrets under the 'secret/data/circleci/*' path
path "secret/data/circleci/*" { 
  capabilities = ["read", "list"] 
}
EOF

##

vault policy read circleci-policy

##

vault write auth/jwt/role/circleci - <<EOF
{
  "role_type": "jwt",
  "user_claim": "sub",
  "user_claim_json_pointer": "true",
  "bound_claims": {
    "oidc.circleci.com/project-id": "9e6a98cb-e245-4b86-92b9-e44e5c3163b3"
  },
  "policies": ["default", "circleci-policy"],
  "ttl": "10m"
}
EOF

##

vault secrets enable -version=2 -path=secret kv

##

vault kv put secret/circleci/secrets \
  username="denis.lemire" \
  password="h@wts@auce"

vault kv get secret/circleci/secrets
