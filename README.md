# Resourcely GitLab Template

This template allows you to easily add Resourcely infrastructure guardrail validation job
to your GitLab projects. The Resourcely infrastructure guardrail validation job will scan
Terraform plans within your GitLab merge-requests and validate them against the guardrails
you have configured in Resourcely.

To learn more about Resourcely, visit [https://www.resourcely.io/](https://www.resourcely.io/). For guidance on the Resourcely GitLab integration see:

- [Resourcely GitLab SCM Integration](https://docs.resourcely.com/getting-started/onboarding/source-code-management-integration/gitlab)
- [Resourcely GitLab CI/CD Setup](https://docs.resourcely.com/getting-started/onboarding/ci-cd-setup/gitlab-pipelines)
- [Resourcely Guardrail Validation in Action](https://docs.resourcely.com/getting-started/using-resourcely/guardrails-in-action/gitlab-pipelines)

## Prerequisites

In order to use this template, you must have the following prerequisties configured:

- [Maintainer Role](https://docs.gitlab.com/ee/user/permissions.html#roles) in the project you want to run the Resourcely infrastructure validation job on
- [Required Environment Variables](https://docs.resourcely.com/getting-started/onboarding/ci-cd-setup/gitlab-pipelines#adding-required-variables-to-the-repository) added to your project

## Usage

To apply this template to your GitLab CI/CD pipline, simply add the following to
your [.gitlab-ci.yml](https://docs.gitlab.com/ee/ci/).

```
# Resourcely CI runs on the test stage of a GitLab pipeline
stage:
  - test

include:
  - remote: 'https://raw.githubusercontent.com/Resourcely-Inc/resourcely-gitLab-template/main/.resourcely.gitlab-ci.yml'
```

## Configurations

You can configure how the Resourcely job by adding the following variables to
your project's .gitlab-ci.yml:

| Name | Description | Default Value |
| ---- | ----------- | ------------- |
| TF_DIRECTORY | The location of the Terraform files to be validated | $CI_PROJECT_DIR |
| RESOURCELY_API_HOST | The location of the Resourcely API you are using | "https://api.resourcely.io" |
| RESOURCELY_DEBUG | Enables Resourcely bebug logs | "false" |
