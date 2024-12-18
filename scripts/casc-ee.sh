#!/usr/bin/bash

EVENT_UUID=$(uuidgen)
WEBHOOK_UUID=$(uuidgen)

curl -v -k -X POST https://your_gitlab_webhook_url_as_generated_in_the_Workflow_Job_Template \
  -H "Host: your_controller_name_or_IP.here" \
  -H "User-Agent: GitLab/16.11.6-ee" \
  -H "Accept: */*" \
  -H "Accept-Encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3" \
  -H "Content-Type: application/json" \
  -H "X-Forwarded-Host: your_controller_name_or_IP.here" \
  -H "X-Forwarded-Proto: https" \
  -H "X-Gitlab-Event: Push Hook" \
  -H "X-Gitlab-Event-Uuid: $EVENT_UUID" \
  -H "X-Gitlab-Instance: https://gitlab.dan.com" \
  -H "X-Gitlab-Token: YOUR_Webhook_Key" \
  -H "X-Gitlab-Webhook-Uuid: $WEBHOOK_UUID" \
  -d "{\"key\": "\"$1"\", \"key2\": "\"$WEBHOOK_UUID"\" }"

