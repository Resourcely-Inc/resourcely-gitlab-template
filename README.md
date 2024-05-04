# Resourcely GitLab Guardrail Template

This repository houses the [GitLab CICD Configuration](https://docs.gitlab.com/ee/ci/yaml/includes.html) for running
the Resourcely guardrail validator.

It can be easily added to your GitLab pipeline by including the template in your [.gitlab-ci.yml](https://docs.gitlab.com/ee/ci/#the-gitlab-ciyml-file):
```yaml
stage:
  - test

include:
  - remote: 'https://raw.githubusercontent.com/Resourcely-Inc/resourcely-gitlab-template/main/.resourcely.gitlab-ci.yml'
```

See the following for examples on how to implement this template:

- [GitLab CI/CD](https://github.com/Resourcely-Inc/scaffolding-gitlab-pipeline)
- [GitLab CI/CD + Terraform Cloud](https://github.com/Resourcely-Inc/scaffolding-gitlab-pipeline-terraform-cloud)

## Prereqisites

1. [A Resourcely Account](https://docs.resourcely.io/resourcely-terms/user-management/resourcely-account)
2. [Resourcely GitLab SCM Configured](https://docs.resourcely.io/integrations/source-code-management/gitlab)
3. [GitLab Premium or Ultimate subscription](https://about.gitlab.com/pricing/)
4. [Maintainer Role or Higher](https://docs.gitlab.com/ee/user/permissions.html#roles) in the GitLab project

## Usage

In order to add the Resourcely guardrail validation job to your GitLab pipeline, you must perform the following:

1. [Generate a Resourcely API Token](https://docs.resourcely.io/onboarding/api-access-token-generation) and save it in a safe place
2. Add your Resourcely API Token to your [GitLab project CI/CD variables](https://docs.gitlab.com/ee/ci/variables/)  
  a. Go to the GitLab project that Resourcely will validate  
  b. In the side tab, navigate to **Settings > CI/CD**  
  c. Expand the **Variables** tab  
  d. Click the **Add variable** button  
  e. Add `RESOURCELY_API_TOKEN` as the Key and the **token** as the value  
  f. Evaluate whether to unselect **Protect variable**, depending on the need to use the token in un-protected branches, while considering security implications  
  g. Select the **Mask variable** to protect sensitive data from being seen in job logs  
  h. Unselect **Expand variable reference**  
  i. Press the **Add variable** button  
3. Add required [Terraform Provider Credentials](https://developer.hashicorp.com/terraform/language/providers) or [Terraform Cloud Team Token]((https://developer.hashicorp.com/terraform/cloud-docs/users-teams-organizations/api-tokens#team-api-tokens)) to your GitLab project CI/CD variables as done in step 2
4. Create or edit your `.gitlab-ci.yml` file in the root of your GitLab project
5. Import the Resourcely template
  ```yaml
  stage:
    - test

  include:
    - remote: 'https://raw.githubusercontent.com/Resourcely-Inc/resourcely-gitlab-template/main/.resourcely.gitlab-ci.yml'
  ```
6. Create a Resource with Resourcely

Once a new Resource has been created via Merge-Request, the Resourcely job will automatically kick-off. It runs in
the **test** stage by default.

## Configuration Variables

The Resourcely template can be customized by overwriting the following variables in your `.gitlab-ci.yml`:

| Variable | Description | Default |
| -------- | ----------- | ------- |
| TF_PLAN_DIRECTORY | The directory of the Terraform plans to validate | `$CI_PROJECT_DIR` |
| TF_PLAN_PATTERN | The pattern to scan for under the TF_PLAN_DIRECTORY; Supports wildcards | "plan*" |
| CHANGE_REQUEST_URL | The URL of the merge-request to validate | `$CI_MERGE_REQUEST_PROJECT_URL/-/merge_requests/$CI_MERGE_REQUEST_IID` |
| RESOURCELY_API_HOST | The Resourcely API host | "https://api.resourcely.io" |
| RESOURCELY_IMAGE | The Resourcely container image version | "latest" |
| RESOURCELY_DEBUG | Enable debug mode | "false" |
| RESOURCELY_MANIFEST_PATH | The location of a Resourcely manifest file; If set will scan the directories present in the manifest and ignore `TF_PLAN_DIRECTORY` and `TF_PLAN_PATTERN` | "" |

## How to Configure

You can override the `resourcely_guardrails` job definition within your project's `.gitlab-ci.yml`.

The following: 

- Sets the Resourcely guardrail job to run in a stage named **security**
- Sets the `TF_PLAN_DIRECTORY` to **/plans** telling Resourcely to look for plans in the **/plans** directory
- Sets the `TF_PLAN_PATTERN` to **"*.json"** telling Resourcely to scan all **json** files
- Sets `allow_failure` to false, meaning if the `resourcely_guardrails` job fails, then the pipeline will not proceed

```yaml
stages:
  - security

include:
  - remote: 'https://raw.githubusercontent.com/Resourcely-Inc/resourcely-gitlab-template/main/.resourcely.gitlab-ci.yml'

resourcely_guardrails:
  stage: security
  variables:
    TF_PLAN_DIRECTORY: /plans
    TF_PLAN_PATTERN: "*.json"
  allow_failure: false
```

### Scanning for plans generated in multiple directories

The `resourcely_guardrails` job can scan Terraform plans in multiple directories. This can be done by creating a
manifest json as follows:

```json
{
  "plans": [{
    "plan_file": "dev/plan.json",
    "config_root_path": "dev"
  },{
    "plan_file": "prod/plan.json",
    "config_root_path": "prod"
  }]
}
```

A manifest is a list of plans composed of the following directives:

* **plan_file**: The full path to where the Terraform plan file will be generated
* **config_root_path**: the directory from where your Terraform plan is generated

Then you must set the `RESOURCELY_MANIFEST_PATH` to the location of the manifest json: 

```yaml
stages:
  - test

variables:
  RESOURCELY_MANIFEST_PATH: /path/to/manifest.json

include:
  - remote: 'https://raw.githubusercontent.com/Resourcely-Inc/resourcely-gitlab-template/main/.resourcely.gitlab-ci.yml'
```

Then Resourcely will scan the plans defined in the manifest. Note that with the GitLab
project, the root (/) is at [$CI_PROJECT_DIR](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html).

#### Generating/Downloading the manifest file in GitLab

Additionally you can generate the manifest file in GitLab before the `resourcely_guardrail` job is run.
This can be done as follows:

```yaml
stages:
  - manifest
  - test

variables:
  RESOURCELY_MANIFEST_PATH: manifest.json

include:
  - remote: 'https://raw.githubusercontent.com/Resourcely-Inc/resourcely-gitlab-template/main/.resourcely.gitlab-ci.yml'

generate_manifest:
  stage: manifest
  script:
    - |
      cat > manifest.json << EOF
      {
      "plans": [{
      "plan_file": "dev/plan.json",
      "config_root_path": "dev"
      },{
      "plan_file": "prod/plan.json",
      "config_root_path": "prod"
      }]
      }
      EOF
  artifacts:
    paths:
      - manifest.json
```

This will generate a manifest json and store it as an artifact which the `resourcely_guardrails` job
can access.