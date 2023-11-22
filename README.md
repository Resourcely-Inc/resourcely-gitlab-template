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

- [Maintainer Access]() to the Project you will add the Resourcely job to
- [Required Environment Variables]() added to your Project

## Usage

To apply this template to your 

```
# Resourcely CI runs on the test stage of a GitLab pipeline
stage:
  - test

include:
  - remote: 'https://gitlab.com/awesome-project/raw/main/.before-script-template.yml'
```

## Configurations

You can configure how the Resourcely job by adding the following variables to
your project's .gitlab-ci.yml:

```
variables:
  OK: OK
```
