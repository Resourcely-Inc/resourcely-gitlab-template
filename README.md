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

## Template Configuration

The Resourcely template can be customized by overwriting the following variables in your `.gitlab-ci.yml`:

| Variable | Description | Default |
| -------- | ----------- | ------- |
| TF_PLAN_DIRECTORY | The directory of the Terraform plans to validate | `$CI_PROJECT_DIR` |
| TF_PLAN_PATTERN | The pattern to scan for under the TF_PLAN_DIRECTORY; Supports wildcards | "plan*" |
| CHANGE_REQUEST_URL | The URL of the merge-request to validate | `$CI_MERGE_REQUEST_PROJECT_URL/-/merge_requests/$CI_MERGE_REQUEST_IID` |
| RESOURCELY_API_HOST | The Resourcely API host | "https://api.resourcely.io" |
| RESOURCELY_IMAGE | The Resourcely container image version | "latest" |
| RESOURCELY_DEBUG | Enable debug mode | "false" |

Additionally you can run the Resourcely guardrail job in another stage by overwriting the job definition in your
`.gitlab-ci.yml`. The following example sets the Resourcely guardrail job to run in a stage named **security**, and sets the `TF_PLAN_DIRECTORY` to **/plans**:

```yaml
stages:
  - security

resourcely_guardrails:
  stage: security
  variables:
    TF_PLAN_DIRECTORY: /plans
```