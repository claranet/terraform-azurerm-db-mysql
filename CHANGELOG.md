# v2.4.0 - Unreleased

Added
  * AZ-230: Add auto-grow parameter on storage_profile block

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

