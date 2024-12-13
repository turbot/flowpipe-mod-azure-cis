locals {
  cis_v300_2_control_mapping = {
    cis_v300_2_1_1 = pipeline.cis_v300_2_1_1
    cis_v300_2_1_2 = pipeline.cis_v300_2_1_2
    cis_v300_2_1_3 = pipeline.cis_v300_2_1_3
    cis_v300_2_1_4 = pipeline.cis_v300_2_1_4
    cis_v300_2_2_1 = pipeline.cis_v300_2_2_1
    cis_v300_2_2_2 = pipeline.cis_v300_2_2_2
    cis_v300_2_2_3 = pipeline.cis_v300_2_2_3
    cis_v300_2_2_4 = pipeline.cis_v300_2_2_4
    cis_v300_2_2_5 = pipeline.cis_v300_2_2_5
    cis_v300_2_2_6 = pipeline.cis_v300_2_2_6
    cis_v300_2_2_7 = pipeline.cis_v300_2_2_7
    cis_v300_2_2_8 = pipeline.cis_v300_2_2_8
    cis_v300_2_3   = pipeline.cis_v300_2_3
    cis_v300_2_4   = pipeline.cis_v300_2_4
    cis_v300_2_5   = pipeline.cis_v300_2_5
    cis_v300_2_6   = pipeline.cis_v300_2_6
    cis_v300_2_7   = pipeline.cis_v300_2_7
    cis_v300_2_8   = pipeline.cis_v300_2_8
    cis_v300_2_9   = pipeline.cis_v300_2_9
    cis_v300_2_10  = pipeline.cis_v300_2_10
    cis_v300_2_11  = pipeline.cis_v300_2_11
    cis_v300_2_12  = pipeline.cis_v300_2_12
    cis_v300_2_13  = pipeline.cis_v300_2_13
    cis_v300_2_14  = pipeline.cis_v300_2_14
    cis_v300_2_15  = pipeline.cis_v300_2_15
    cis_v300_2_16  = pipeline.cis_v300_2_16
    cis_v300_2_17  = pipeline.cis_v300_2_17
    cis_v300_2_18  = pipeline.cis_v300_2_18
    cis_v300_2_19  = pipeline.cis_v300_2_19
    cis_v300_2_20  = pipeline.cis_v300_2_20
    cis_v300_2_21  = pipeline.cis_v300_2_21
    cis_v300_2_22  = pipeline.cis_v300_2_22
    cis_v300_2_23  = pipeline.cis_v300_2_23
    cis_v300_2_24  = pipeline.cis_v300_2_24
    cis_v300_2_25  = pipeline.cis_v300_2_25
    cis_v300_2_26  = pipeline.cis_v300_2_26
  }
}

pipeline "cis_v300_2" {
  title         = "2 Identity"
  description   = "This section contains recommendations for configuring Azure Identity."
  documentation = file("./cis_v300/docs/cis_v300_2.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2 Identity"
  }

  step "pipeline" "cis_v300_2" {
    depends_on = [step.message.header]

    loop {
      until = loop.index >= (length(keys(local.cis_v300_2_control_mapping)) - 1)
    }

    pipeline = local.cis_v300_2_control_mapping[keys(local.cis_v300_2_control_mapping)[loop.index]]

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_2_1_1" {
  title         = "2.1.1 Ensure Security Defaults is enabled on Microsoft Entra ID"
  description   = "Security defaults in Microsoft Entra ID make it easier to be secure and help protect your organization. Security defaults contain preconfigured security settings for common attacks. Security defaults is available to everyone. The goal is to ensure that all organizations have a basic level of security enabled at no extra cost. You may turn on security defaults in the Azure portal."
  documentation = file("./cis_v300/docs/cis_v300_2_1_1.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity/2.1 Security Defaults (Per-User MFA)"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.1.1 Ensure Security Defaults is enabled on Microsoft Entra ID"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = pipeline.manual_detection

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_1_2" {
  title         = "2.1.2 Ensure that 'Multi-Factor Auth Status' is 'Enabled' for all Privileged Users"
  description   = "Enable multi-factor authentication for all roles, groups, and users that have write access or permissions to Azure resources."
  documentation = file("./cis_v300/docs/cis_v300_2_1_2.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity/2.1 Security Defaults (Per-User MFA)"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.1.2 Ensure that 'Multi-Factor Auth Status' is 'Enabled' for all Privileged Users"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = pipeline.manual_detection

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_1_3" {
  title         = "2.1.3 Ensure that 'Multi-Factor Auth Status' is 'Enabled' for all Non-Privileged Users"
  description   = "Enable multi-factor authentication for all non-privileged users."
  documentation = file("./cis_v300/docs/cis_v300_2_1_3.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity/2.1 Security Defaults (Per-User MFA)"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.1.3 Ensure that 'Multi-Factor Auth Status' is 'Enabled' for all Non-Privileged Users"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = pipeline.manual_detection

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_1_4" {
  title         = "2.1.4 Ensure that 'Allow users to remember multi-factor authentication on devices they trust' is Disabled"
  description   = "Do not allow users to remember multi-factor authentication on devices."
  documentation = file("./cis_v300/docs/cis_v300_2_1_4.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity/2.1 Security Defaults (Per-User MFA)"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.1.4 Ensure that 'Allow users to remember multi-factor authentication on devices they trust' is Disabled"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = pipeline.manual_detection

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_2_1" {
  title         = "2.2.1 Ensure Trusted Locations Are Defined"
  description   = "Microsoft Entra ID Conditional Access allows an organization to configure Named locations and configure whether those locations are trusted or untrusted. These settings provide organizations the means to specify Geographical locations for use in conditional access policies, or define actual IP addresses and IP ranges and whether or not those IP addresses and/or ranges are trusted by the organization."
  documentation = file("./cis_v300/docs/cis_v300_2_2_1.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity/2.2 Conditional Access"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.2.1 Ensure Trusted Locations Are Defined"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = pipeline.manual_detection

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_2_2" {
  title         = "2.2.2 Ensure that an exclusionary Geographic Access Policy is considered"
  description   = "Conditional Access Policies can be used to block access from geographic locations that are deemed out-of-scope for your organization or application. The scope and variables for this policy should be carefully examined and defined."
  documentation = file("./cis_v300/docs/cis_v300_2_2_2.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity/2.2 Conditional Access"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.2.2 Ensure that an exclusionary Geographic Access Policy is considered"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = pipeline.manual_detection

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_2_3" {
  title         = "2.2.3 Ensure that an exclusionary Device code flow policy is considered"
  description   = "Conditional Access Policies can be used to prevent the Device code authentication flow. Device code flow should be permitted only for users that regularly perform duties that explicitly require the use of Device Code to authenticate, such as utilizing Azure with PowerShell."
  documentation = file("./cis_v300/docs/cis_v300_2_2_3.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity/2.2 Conditional Access"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.2.3 Ensure that an exclusionary Device code flow policy is considered"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = pipeline.manual_detection

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_2_4" {
  title         = "2.2.4 Ensure that A Multi-factor Authentication Policy Exists for Administrative Groups"
  description   = "For designated users, they will be prompted to use their multi-factor authentication (MFA) process on login."
  documentation = file("./cis_v300/docs/cis_v300_2_2_4.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity/2.2 Conditional Access"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.2.4 Ensure that A Multi-factor Authentication Policy Exists for Administrative Groups"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = pipeline.manual_detection

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_2_5" {
  title         = "2.2.5 Ensure that A Multi-factor Authentication Policy Exists for All Users"
  description   = "For designated users, they will be prompted to use their multi-factor authentication (MFA) process on logins."
  documentation = file("./cis_v300/docs/cis_v300_2_2_5.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity/2.2 Conditional Access"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.2.5 Ensure that A Multi-factor Authentication Policy Exists for All Users"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = pipeline.manual_detection

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_2_6" {
  title         = "2.2.6 Ensure Multi-factor Authentication is Required for Risky Sign-ins"
  description   = "Entra ID tracks the behavior of sign-in events. If the Entra ID domain is licensed with P2, the sign-in behavior can be used as a detection mechanism for additional scrutiny during the sign-in event. If this policy is set up, then Risky Sign-in events will prompt users to use multi-factor authentication (MFA) tokens on login for additional verification."
  documentation = file("./cis_v300/docs/cis_v300_2_2_6.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity/2.2 Conditional Access"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.2.6 Ensure Multi-factor Authentication is Required for Risky Sign-ins"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = pipeline.manual_detection

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_2_7" {
  title         = "2.2.7 Ensure Multifactor Authentication is Required for Windows Azure Service Management API"
  description   = "This recommendation ensures that users accessing the Windows Azure Service Management API (i.e. Azure Powershell, Azure CLI, Azure Resource Manager API, etc.) are required to use multifactor authentication (MFA) credentials when accessing resources through the Windows Azure Service Management API."
  documentation = file("./cis_v300/docs/cis_v300_2_2_7.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity/2.2 Conditional Access"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.2.7 Ensure Multifactor Authentication is Required for Windows Azure Service Management API"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = pipeline.manual_detection

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_2_8" {
  title         = "2.2.8 Ensure Multifactor Authentication is Required to access Microsoft Admin Portals"
  description   = "This recommendation ensures that users accessing Microsoft Admin Portals (i.e. Microsoft 365 Admin, Microsoft 365 Defender, Exchange Admin Center, Azure Portal, etc.) are required to use multifactor authentication (MFA) credentials when logging into an Admin Portal."
  documentation = file("./cis_v300/docs/cis_v300_2_2_8.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity/2.2 Conditional Access"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.2.8 Ensure Multifactor Authentication is Required to access Microsoft Admin Portals"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = pipeline.manual_detection

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_3" {
  title         = "2.3 Ensure that 'Restrict non-admin users from creating tenants' is set to 'Yes'"
  description   = "Require administrators or appropriately delegated users to create new tenants."
  documentation = file("./cis_v300/docs/cis_v300_2_3.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.3 Ensure that 'Restrict non-admin users from creating tenants' is set to 'Yes'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = pipeline.manual_detection

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_4" {
  title         = "2.4 Ensure Guest Users Are Reviewed on a Regular Basis"
  description   = "Microsoft Entra ID has native and extended identity functionality allowing you to invite people from outside your organization to be guest users in your cloud account and sign in with their own work, school, or social identities."
  documentation = file("./cis_v300/docs/cis_v300_2_4.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.4 Ensure Guest Users Are Reviewed on a Regular Basis"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_tenants_with_guest_users

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_2_5" {
  title         = "2.5 Ensure That 'Number of methods required to reset' is set to '2'"
  description   = "Ensures that two alternate forms of identification are provided before allowing a password reset."
  documentation = file("./cis_v300/docs/cis_v300_2_5.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.5 Ensure That 'Number of methods required to reset' is set to '2'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = pipeline.manual_detection

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_6" {
  title         = "2.6 Ensure that account 'Lockout Threshold' is less than or equal to '10'"
  description   = "The account lockout threshold determines how many failed login attempts are permitted prior to placing the account in a locked-out state and initiating a variable lockout duration."
  documentation = file("./cis_v300/docs/cis_v300_2_6.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.6 Ensure that account 'Lockout Threshold' is less than or equal to '10'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = pipeline.manual_detection

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_7" {
  title         = "2.7 Ensure that account 'Lockout duration in seconds' is greater than or equal to '60'"
  description   = "The account lockout duration value determines how long an account retains the status of lockout, and therefore how long before a user can continue to attempt to login after passing the lockout threshold."
  documentation = file("./cis_v300/docs/cis_v300_2_7.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.7 Ensure that account 'Lockout duration in seconds' is greater than or equal to '60'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = pipeline.manual_detection

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_8" {
  title         = "2.8 Ensure that a Custom Bad Password List is set to 'Enforce' for your Organization"
  description   = "Microsoft Azure provides a Global Banned Password policy that applies to Azure administrative and normal user accounts. This is not applied to user accounts that are synced from an on-premise Active Directory unless Azure AD Connect is used and you enable EnforceCloudPasswordPolicyForPasswordSyncedUsers. Please see the list in default values on the specifics of this policy. To further password security, it is recommended to further define a custom banned password policy"
  documentation = file("./cis_v300/docs/cis_v300_2_8.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.8 Ensure that a Custom Bad Password List is set to 'Enforce' for your Organization"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = pipeline.manual_detection

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_9" {
  title         = "2.9 Ensure that 'Number of days before users are asked to re-confirm their authentication information' is not set to '0'"
  description   = "Ensure that the number of days before users are asked to re-confirm their authentication information is not set to 0."
  documentation = file("./cis_v300/docs/cis_v300_2_9.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.9 Ensure that 'Number of days before users are asked to re-confirm their authentication information' is not set to '0'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = pipeline.manual_detection

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_10" {
  title         = "2.10 Ensure that 'Notify users on password resets?' is set to 'Yes'"
  description   = "Ensure that users are notified on their primary and alternate emails on password resets."
  documentation = file("./cis_v300/docs/cis_v300_2_10.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.10 Ensure that 'Notify users on password resets?' is set to 'Yes'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = pipeline.manual_detection

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_11" {
  title         = "2.11 Ensure That 'Notify all admins when other admins reset their password?' is set to 'Yes'"
  description   = "Ensure that all Global Administrators are notified if any other administrator resets their password."
  documentation = file("./cis_v300/docs/cis_v300_2_11.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.11 Ensure That 'Notify all admins when other admins reset their password?' is set to 'Yes'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = pipeline.manual_detection

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_12" {
  title         = "2.12 Ensure 'User consent for applications' is set to 'Do not allow user consent'"
  description   = "Require administrators to provide consent for applications before use."
  documentation = file("./cis_v300/docs/cis_v300_2_12.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.12 Ensure 'User consent for applications' is set to 'Do not allow user consent'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = pipeline.manual_detection

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_13" {
  title         = "2.13 Ensure 'User consent for applications' Is Set To 'Allow for Verified Publishers'"
  description   = "Allow users to provide consent for selected permissions when a request is coming from a verified publisher."
  documentation = file("./cis_v300/docs/cis_v300_2_13.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.13 Ensure 'User consent for applications' Is Set To 'Allow for Verified Publishers'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = pipeline.manual_detection

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_14" {
  title         = "2.14 Ensure That 'Users Can Register Applications' Is Set to 'No'"
  description   = "Require administrators or appropriately delegated users to register third-party applications."
  documentation = file("./cis_v300/docs/cis_v300_2_14.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.14 Ensure That 'Users Can Register Applications' Is Set to 'No'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_iam_users_allowed_to_register_application

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_2_15" {
  title         = "2.15 Ensure That 'Guest users access restrictions' is set to 'Guest user access is restricted to properties and memberships of their own directory objects'"
  description   = "Limit guest user permissions."
  documentation = file("./cis_v300/docs/cis_v300_2_15.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.15 Ensure That 'Guest users access restrictions' is set to 'Guest user access is restricted to properties and memberships of their own directory objects'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = pipeline.manual_detection

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_16" {
  title         = "2.16 Ensure that 'Guest invite restrictions' is set to 'Only users assigned to specific admin roles can invite guest users'"
  description   = "Restrict invitations to users with specific administrative roles only."
  documentation = file("./cis_v300/docs/cis_v300_2_16.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.16 Ensure that 'Guest invite restrictions' is set to 'Only users assigned to specific admin roles can invite guest users'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = pipeline.manual_detection

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_17" {
  title         = "2.17 Ensure That 'Restrict access to Microsoft Entra admin center' is Set to 'Yes'"
  description   = "Restrict access to the Azure AD administration portal to administrators only."
  documentation = file("./cis_v300/docs/cis_v300_2_17.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.17 Ensure That 'Restrict access to Microsoft Entra admin center' is Set to 'Yes'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = pipeline.manual_detection

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_18" {
  title         = "2.18 Ensure that 'Restrict user ability to access groups features in the Access Pane' is Set to 'Yes'"
  description   = "Restrict access to group web interface in the Access Panel portal."
  documentation = file("./cis_v300/docs/cis_v300_2_18.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.18 Ensure that 'Restrict user ability to access groups features in the Access Pane' is Set to 'Yes'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = pipeline.manual_detection

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_19" {
  title         = "2.19 Ensure that 'Users can create security groups in Azure portals, API or PowerShell' is set to 'No'"
  description   = "Restrict security group creation to administrators only."
  documentation = file("./cis_v300/docs/cis_v300_2_19.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.19 Ensure that 'Users can create security groups in Azure portals, API or PowerShell' is set to 'No'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_iam_users_allowed_to_create_security_group

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_2_20" {
  title         = "2.20 Ensure that 'Owners can manage group membership requests in the Access Panel' is set to 'No'"
  description   = "Restrict security group management to administrators only."
  documentation = file("./cis_v300/docs/cis_v300_2_20.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.20 Ensure that 'Owners can manage group membership requests in the Access Panel' is set to 'No'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = pipeline.manual_detection

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_21" {
  title         = "2.21 Ensure that 'Users can create Microsoft 365 groups in Azure portals, API or PowerShell' is set to 'No'"
  description   = "Restrict Microsoft 365 group creation to administrators only."
  documentation = file("./cis_v300/docs/cis_v300_2_21.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.21 Ensure that 'Users can create Microsoft 365 groups in Azure portals, API or PowerShell' is set to 'No'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = pipeline.manual_detection

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_22" {
  title         = "2.22 Ensure that 'Require Multi-Factor Authentication to register or join devices with Microsoft Entra ID' is set to 'Yes'"
  description   = "Joining or registering devices to the active directory should require Multi-factor authentication."
  documentation = file("./cis_v300/docs/cis_v300_2_22.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.22 Ensure that 'Require Multi-Factor Authentication to register or join devices with Microsoft Entra ID' is set to 'Yes'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = pipeline.manual_detection

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_23" {
  title         = "2.23 Ensure That No Custom Subscription Administrator Roles Exist"
  description   = "The principle of least privilege should be followed and only necessary privileges should be assigned instead of allowing full administrative access."
  documentation = file("./cis_v300/docs/cis_v300_2_23.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.23 Ensure That No Custom Subscription Administrator Roles Exist"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_iam_subscriptions_with_custom_owner_roles

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_24" {
  title         = "2.24 Ensure a Custom Role is Assigned Permissions for Administering Resource Locks"
  description   = "Resource locking is a powerful protection mechanism that can prevent inadvertent modification/deletion of resources within Azure subscriptions/Resource Groups and is a recommended NIST configuration."
  documentation = file("./cis_v300/docs/cis_v300_2_24.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.24 Ensure a Custom Role is Assigned Permissions for Administering Resource Locks"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = pipeline.manual_detection

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_25" {
  title         = "2.25 Ensure That `Subscription leaving Microsoft Entra ID directory` and `Subscription entering Microsoft Entra ID directory` Is Set To 'Permit No One'"
  description   = "Users who are set as subscription owners are able to make administrative changes to the subscriptions and move them into and out of Azure Active Directories."
  documentation = file("./cis_v300/docs/cis_v300_2_25.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.25 Ensure That `Subscription leaving Microsoft Entra ID directory` and `Subscription entering Microsoft Entra ID directory` Is Set To 'Permit No One'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = pipeline.manual_detection

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_26" {
  title         = "2.26 Ensure fewer than 5 users have global administrator assignment"
  description   = "This recommendation aims to maintain a balance between security and operational efficiency by ensuring that a minimum of 2 and a maximum of 4 users are assigned the Global Administrator role in Microsoft Entra ID. Having at least two Global Administrators ensures redundancy, while limiting the number to four reduces the risk of excessive privileged access."
  documentation = file("./cis_v300/docs/cis_v300_2_25.md")

  tags = {
    folder = "CIS v3.0.0/2 Identity"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "2.26 Ensure fewer than 5 users have global administrator assignment"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_tenants_with_more_than_five_iam_global_administrator

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}