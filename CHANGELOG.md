# Unreleased

Changed
  * AZ-901: Change default value for `public_network_access_enabled` variable to `false`  

# v6.0.0 - 2022-07-01

Breaking
  * AZ-717: Require Terraform 1.1+
  * AZ-717: Bump AzureRM provider version to `v3.0+`
  * AZ-762: Externalize `mysql-users` as a separated module in a dedicated repo (to create admin users per database)

# v5.3.0 - 2022-06-24

Added
  * AZ-770: Add Terraform module info in output

# v5.2.0 - 2022-06-10

Added
  * AZ-775: Added `force_ssl_minimal_version` variable to fix plan with force_ssl=false

# v5.1.0 - 2022-04-08

Added
  * AZ-615: Add an option to enable or disable default tags

# v5.0.0 - 2022-02-03

Breaking
  * AZ-515: Option to use Azure CAF naming provider to name resources
  * AZ-589: Bump `diagnostics` module to latest v5.0.0

# v4.5.0 - 2022-02-03

Added
  * AZ-623: Add default mysql options, can be overriden with `mysql_options` variable
    ```
    log_bin_trust_function_creators = "ON"
    connect_timeout                 = 60
    interactive_timeout             = 28800
    wait_timeout                    = 28800
    ```

# v4.4.1 - 2021-11-30

Fixed
  * AZ-617: Fix outputs when no user

# v4.4.0 - 2021-11-23

Breaking
  * AZ-531: Rework module with new MySQL provider

# v4.3.0 - 2021-11-23

Added
  * AZ-568: Add threat detection policy option
  * AZ-566: Add public network access option

Changed
  * AZ-572: Revamp examples and improve CI

Fixed
  * AZ-589: Avoid plan drift when specifying Diagnostic Settings categories

# v3.2.1/v4.2.1 - 2021-08-27

Changed
  * AZ-532: Revamp README with latest `terraform-docs` tool

# v3.2.0/v4.2.0 - 2021-06-07

Breaking
  * AZ-160: Unify diagnostics settings on all Claranet modules

# v3.1.1/v4.1.1 - 2021-03-09

Fixed
  * AZ-461: Remove sensitive attribute on databases users output

# v3.1.0/v4.1.0 - 2021-01-08

Changed
  * AZ-398: Force lowercase on default generated name

# v3.0.1/v4.0.0 - 2020-11-18

Changed
  * AZ-273: Update README and CI, module compatible Terraform 0.13+ (now requires Terraform 0.12.26 minimum version)

# v3.0.0 - 2020-07-27

Breaking
  * AZ-198: Upgrade for compatibility AzureRM 2.0

# v2.4.0 - 2020-07-09

Changed
  * AZ-206: Pin version AzureRM provider to be usable < 2.0
  * AZ-209: Update CI with Gitlab template

Added
  * AZ-230: Add auto-grow parameter on `storage_profile` block

# v2.3.0 - 2020-03-27

Changed
  * AZ-202: use `sku_name` string parameter instead of deprecated `sku` map parameter

# v2.2.0 - 2020-02-11

Breaking
  * AZ-166: Use `random_password` instead of `random_string` for passwords generation: **this changes the generated value or need manual state edition**

Changed
  * AZ-182: Allow no `_user` suffix

# v2.1.0 - 2019-12-18

Changed
  * AZ-149: Improve VNet rules use and fix output

# v2.0.0 - 2019-11-25

Breaking
  * AZ-94: Terraform 0.12 / HCL2 format

Added
  * AZ-128: Create databases users
  * AZ-118: Add LICENSE, NOTICE & Github badges
  * AZ-119: Revamp README and publish this module to Terraform registry
  * AZ-119: Add CONTRIBUTING.md doc and `terraform-wrapper` usage with the module

# v0.1.0 - 2019-07-02

Added
  * AZ-44 + TER-306: First release

