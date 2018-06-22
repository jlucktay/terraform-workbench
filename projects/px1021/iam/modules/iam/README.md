# README

## Abstract

Takes a list of role names as an input variable, where the list is delimited by a character that is also supplied as an input variable.

Creates one IAM role per name given.

The roles will be classified as one of two different types:

- **SSO** roles are those that trust (and can be assumed by) the GSuite/SAML identity provider.
- **Jump** roles are those that trust (and can be assumed by) the **SSO** roles.

## Local manifest

- `policy.assume.tf`
  - policy documents for which upstream entities to trust
    - **SSO** roles in the `tidal-auth` account will trust the GSuite/SAML identity provider
    - **Jump** roles in *all* accounts will trust the **SSO** roles
- `role.tf`
  - core role definition
  - no policies attached as of yet
- `split.tf`
  - some fancy wiring to get around the lack of support for 'count' attribute in modules
    - see the following for more:
      - [Working around the lack of count in Terraform modules](https://serialseb.com/blog/2016/05/11/terraform-working-around-no-count-on-module/)
      - [Support the count parameter for modules #953](https://github.com/hashicorp/terraform/issues/953)
- `var.tf`
  - inputs to make the whole thing go
