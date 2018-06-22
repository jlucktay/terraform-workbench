# README

## Abstract

In the design of this module, I am putting roles into one of two buckets: **SSO** and **jump**.

**SSO** roles are those that trust (and can be assumed by) the GSuite/SAML identity provider.

**Jump** roles are those that trust (and can be assumed by) the **SSO** roles.

## `iam` module

Has its own `README.md` in addition to this one, so check there also.

Broadly speaking, this module will take a list of role names, and create each of them in the targeted AWS account.

## Local manifest

- `config.tf`
  - boilerplate backend set up
  - includes multiple AWS providers
    - could potentially do all roles at once across all accounts, if we feed it enough credentials/profiles
- `tidal-auth-jump.tf`
  - uses the module to create **jump**-type roles for the `tidal-auth` account that will be jumped into by other roles of type **SSO**
- `tidal-auth-sso.tf`
  - uses the module to create **SSO**-type roles for the `tidal-auth` account that will be jumped into via GSuite/SAML SSO
- `var.tf`
  - some inputs for this group of templates
    - `region`
      - AWS region
        - mostly redundant/pointless since we are only dealing with IAM resources which are in a global namespace
      - no default value for this
    - `role-delimiter`
      - defaults to a space ' ' character
      - using a variable for this in case it needs to be changed somewhere down the track for some reason
