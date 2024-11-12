# Azure AD User Onboarding Terraform Module

## Overview

The **Azure AD User Onboarding** Terraform module automates the process of managing user access within Azure Active Directory (Azure AD). It streamlines onboarding by:

- **Consolidating Email Inputs**: Accepts a list of user email addresses for onboarding.
- **Automated Invitations**: Sends invitations to external users who are not part of the tenant.
- **Security Group Management**: Creates a dedicated Azure AD security group.
- **Group Membership Assignment**: Adds invited users to the security group.

## Features

- **Efficient User Management**: Automates the invitation and group assignment process.
- **Customizable Invitations**: Personalize invitation messages and specify additional recipients.
- **Security Group Provisioning**: Automatically creates and manages Azure AD security groups.
- **Scalable Design**: Suitable for organizations of all sizes, facilitating bulk user management.

## Requirements

- **Terraform**: Version 1.0 or later.
- **Providers**:
  - [`azuread`](https://registry.terraform.io/providers/hashicorp/azuread/latest) version `>= 2.22.0`.

## Module Inputs

| Variable Name                | Description                                                  | Type           | Default                                  | Required |
|------------------------------|--------------------------------------------------------------|----------------|------------------------------------------|----------|
| `emails`                     | List of user email addresses for onboarding.                | `list(string)` | N/A                                      | Yes      |
| `group_display_name`         | Display name for the Azure AD security group.               | `string`       | N/A                                      | Yes      |
| `redirect_url`               | The URL to redirect users to after they accept the invitation.| `string`      | `"https://portal.azure.com/"`            | No       |
| `invitation_body`            | The body of the invitation email.                           | `string`       | `"Hello! You are invited to join our Azure AD tenant. Please accept the invitation to gain access."` | No       |
| `additional_recipients`      | Additional email addresses to include in the invitation.     | `list(string)` | `[]`                                     | No       |
| `managed_identity_client_id` | The client ID of the managed identity to use for authentication (optional). | `string` | `null`                                   | No       |

## Module Outputs

| Output Name       | Description                                               |
|-------------------|-----------------------------------------------------------|
| `group_id`        | The ID of the created Azure AD security group.            |
| `group_name`      | The display name of the created security group.           |
| `invited_users`   | List of users who were sent invitations.                  |
| `invited_user_ids`| Map of invited user emails to their Azure AD object IDs.   |

## Usage Example

Here's how you can consume the **Azure AD User Onboarding** module in your Terraform configuration.

### **Directory Structure**

