# Ansible Playbook: Fetch and Configure Execution Environments

## Overview
This repository includes an Ansible playbook, a supporting shell script, an example decision/execution-environment definition file (de-dynatrace.yml), and a GitLab CI configuration. These components collectively automate the process of fetching, building, and uploading Execution Environments (EEs). The workflow involves downloading EE definitions, initiating builds, and seamlessly integrating with GitLab pipelines.
## Components
1. **Ansible Playbook**: `fetch_ee_definition.yml`
2. **Shell Script**: `casc-ee.sh`
3. **DE/EE Definition file (example)**: `de-dynatrace.yml`
3. **GitLab CI Configuration**: `gitlab-ci.yml`

---

## 1. Ansible Playbook: `fetch_ee_definition.yml`
### Purpose
This playbook:
- Downloads an EE definition file from a specified URL.
- Saves the file to a working directory.
- Runs a playbook to build and upload the EE to a hub.
- Cleans up the temporary EE definition file.

### Prerequisites
- Ansible must be installed on the control node.
- Target hosts must have SSH access.
- `awx_webhook_payload.key` must be provided as an external variable, pointing to the EE definition file's URL.

### Tasks
1. **Print `awx_webhook_payload.key`**
   - Verifies and prints the provided EE definition URL.
2. **Download EE Definition**
   - Uses Ansible's `uri` module to fetch the EE definition.
3. **Save EE Definition**
   - Writes the downloaded content to `ee-definition.yml`.
4. **Run Build Playbook**
   - Executes the `playbooks/build_ee.yml` playbook to build and upload the EE.
5. **Cleanup**
   - Removes the temporary `ee-definition.yml` file.

### Usage
Run the playbook with the following command:
```bash
ansible-playbook -i inventory.ini fetch_ee_definition.yml -e "awx_webhook_payload.key=https://example.com/ee-definition.yml"
```

---

## 2. Shell Script: `casc-ee.sh`
### Purpose
The `casc-ee.sh` script sends a webhook POST request to trigger the EE configuration process in a GitLab pipeline.

### How It Works
1. Generates unique UUIDs for `EVENT_UUID` and `WEBHOOK_UUID`.
2. Sends a `POST` request to the webhook endpoint with a JSON payload containing:
   - The EE definition file URL (passed as the first argument `$1`).
   - The generated `WEBHOOK_UUID`.

### Prerequisites
- `curl` must be installed.
- Replace placeholders in the script:
   - `your_gitlab_webhook_url_as_generated_in_the_Workflow_Job_Template`
   - `YOUR_Webhook_Key`
   - `your_controller_name_or_IP.here`

### Usage
Run the script with the EE definition URL as an argument:
```bash
./casc-ee.sh https://example.com/ee-definition.yml
```

---

## 3. DE/EE Definition file (example): `de-dynatrace.yml`
### Purpose
Serves as example of a decision/execution environment file. 

---

## 4. GitLab CI Configuration: `gitlab-ci.yml`
### Purpose
Automates the deployment process by invoking the `casc-ee.sh` script during the `deploy` stage.

### CI Pipeline Stages
- **Stage**: `deploy`
- **Script**: Executes the `casc-ee.sh` script with the EE definition URL as input.

### Example Configuration
```yaml
stages:
  - deploy

deploy1:
  stage: deploy 
  script:
    - /usr/local/bin/casc-ee.sh https://some_gitlab_url.com/keith-dan/example-ee/-/raw/main/de-dynatrace.yml
```

### How It Works
1. GitLab CI triggers the `deploy1` job.
2. The `casc-ee.sh` script is executed with the EE definition URL.
3. This triggers the webhook endpoint, kicking off the EE configuration process.

---

## Workflow Summary
1. **GitLab CI** (`gitlab-ci.yml`):
   - Automates the process by running the shell script casc-ee.sh on a RHEL VM used as gitlab-runner.
2. **Shell Script** (`casc-ee.sh`):
   - Sends the EE definition URL to a webhook endpoint.
3. **Workflow Job Template: sync the project where the EE definition resides, then launching the Ansible Playbook** (`fetch_ee_definition.yml`):
   - Downloads, builds, and uploads the EE.

---

## Directory Structure
```
project-root/
|-- fetch_ee_definition.yml    # Ansible playbook
|-- casc-ee.sh                 # Shell script
|-- gitlab-ci.yml              # GitLab CI configuration
```

---

## Notes
- Ensure all file paths and URLs are correct.
- Validate that `curl` and `Ansible` are installed.
- Replace placeholders in `casc-ee.sh` with actual values.

## License
This project is licensed under the MIT License.

**Authors**: Keith Nelson, Dan Leroux
**Contact**: kenelson@redhat.com, dleroux@redhat.com
