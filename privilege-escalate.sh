#!/usr/bin/env bash

set -Eeuo pipefail

ROLE_NAME="$(cat env.json | jq -r .role_name)"
SUBSCRIPTION_ID="$(az account show --query id -o tsv)"
JUSTIFICATION="Need access for deployment"
DURATION="PT4H"  # 4 hours

echo "Role: $ROLE_NAME"
echo "Subscription: $SUBSCRIPTION_ID"

USER_OBJECT_ID=$(az ad signed-in-user show --query id -o tsv)
echo "User Object ID: $USER_OBJECT_ID"

ROLE_DEFINITION_ID=$(az role definition list --name "$ROLE_NAME" --query "[0].id" -o tsv)

if [[ -z "$ROLE_DEFINITION_ID" ]]; then
    echo "ERROR: Could not find role definition for '$ROLE_NAME'"
    exit 1
fi

echo "Role Definition ID: $ROLE_DEFINITION_ID"
echo

REQUEST_ID=$(uuidgen)

BODY=$(cat <<EOF
{
  "properties": {
    "principalId": "$USER_OBJECT_ID",
    "roleDefinitionId": "$ROLE_DEFINITION_ID",
    "requestType": "SelfActivate",
    "justification": "$JUSTIFICATION",
    "scheduleInfo": {
      "startDateTime": null,
      "expiration": {
        "type": "AfterDuration",
        "duration": "$DURATION"
      }
    }
  }
}
EOF
)

az rest \
  --method put \
  --uri "https://management.azure.com/subscriptions/$SUBSCRIPTION_ID/providers/Microsoft.Authorization/roleAssignmentScheduleRequests/$REQUEST_ID?api-version=2020-10-01" \
  --body "$BODY" \
  --output json
