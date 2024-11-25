locals {
  cis_v300_9_control_mapping = {
    cis_v300_9_1   = pipeline.cis_v300_9_1
    cis_v300_9_2   = pipeline.cis_v300_9_2
    cis_v300_9_3   = pipeline.cis_v300_9_3
    cis_v300_9_4   = pipeline.cis_v300_9_4
    cis_v300_9_5   = pipeline.cis_v300_9_5
    cis_v300_9_6   = pipeline.cis_v300_9_6
    cis_v300_9_7   = pipeline.cis_v300_9_7
    cis_v300_9_8   = pipeline.cis_v300_9_8
		cis_v300_9_9   = pipeline.cis_v300_9_9
		cis_v300_9_10  = pipeline.cis_v300_9_10
    cis_v300_9_11  = pipeline.cis_v300_9_11
    cis_v300_9_12  = pipeline.cis_v300_9_12
  }
}

pipeline "cis_v300_9" {
  title         = "9 App Service"
  description   = "This section contains recommendations for configuring Azure App Service."
  documentation = file("./cis_v300/docs/cis_v300_9.md")

  tags = {
    folder = "CIS v3.0.0/9 App Service"
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
    text     = "9 App Service"
  }

  step "pipeline" "cis_v300_9" {
    depends_on = [step.message.header]

    loop {
      until = loop.index >= (length(keys(local.cis_v300_9_control_mapping)) - 1)
    }

    pipeline = local.cis_v300_9_control_mapping[keys(local.cis_v300_9_control_mapping)[loop.index]]

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_9_1" {
  title         = "9.1 Ensure 'HTTPS Only' is set to `On`"
  description   = "Azure App Service allows apps to run under both HTTP and HTTPS by default. Apps can be accessed by anyone using non-secure HTTP links by default. Non-secure HTTP requests can be restricted and all HTTP requests redirected to the secure HTTPS port. It is recommended to enforce HTTPS-only traffic."
  documentation = file("./cis_v300/docs/cis_v300_9_1.md")

  tags = {
    folder = "CIS v3.0.0/9 App Service"
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
    text     = "9.1 Ensure 'HTTPS Only' is set to `On`"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_appservice_web_apps_not_using_https

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_9_2" {
  title         = "9.2 Ensure App Service Authentication is set up for apps in Azure App Service"
  description   = "Azure App Service Authentication is a feature that can prevent anonymous HTTP requests from reaching a Web Application or authenticate those with tokens before they reach the app. If an anonymous request is received from a browser, App Service will redirect to a logon page. To handle the logon process, a choice from a set of identity providers can be made, or a custom authentication mechanism can be implemented."
  documentation = file("./cis_v300/docs/cis_v300_9_2.md")

  tags = {
    folder = "CIS v3.0.0/9 App Service"
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
    text     = "9.2 Ensure App Service Authentication is set up for apps in Azure App Service"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_appservice_web_apps_with_authentication_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_9_3" {
  title         = "9.3 Ensure 'FTP State' is set to 'FTPS Only' or 'Disabled'"
  description   = "By default, App Services can be deployed over FTP. If FTP is required for an essential deployment workflow, FTPS should be required for FTP login for all App Services. If FTPS is not expressly required for the App, the recommended setting is Disabled."
  documentation = file("./cis_v300/docs/cis_v300_9_3.md")

  tags = {
    folder = "CIS v3.0.0/9 App Service"
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
    text     = "9.3 Ensure 'FTP State' is set to 'FTPS Only' or 'Disabled'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_appservice_web_apps_with_ftp_deployment_enabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_9_4" {
  title         = "9.4 Ensure Web App is using the latest version of TLS encryption"
  description   = "The TLS (Transport Layer Security) protocol secures transmission of data over the internet using standard encryption technology. Encryption should be set with the latest version of TLS. App service allows TLS 1.2 by default, which is the recommended TLS level by industry standards such as PCI DSS."
  documentation = file("./cis_v300/docs/cis_v300_9_4.md")

  tags = {
    folder = "CIS v3.0.0/9 App Service"
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
    text     = "9.4 Ensure Web App is using the latest version of TLS encryption"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_appservice_web_apps_not_using_latest_tls_version

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_9_5" {
  title         = "9.5 Ensure that Register with Entra ID is enabled on App Service"
  description   = "Managed service identity in App Service provides more security by eliminating secrets from the app, such as credentials in the connection strings. When registering an App Service with Entra ID, the app will connect to other Azure services securely without the need for usernames and passwords."
  documentation = file("./cis_v300/docs/cis_v300_9_5.md")

  tags = {
    folder = "CIS v3.0.0/9 App Service"
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
    text     = "9.5 Ensure that Register with Entra ID is enabled on App Service"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_appservice_web_apps_register_with_active_directory_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_9_6" {
  title         = "9.6 Ensure that 'Basic Authentication' is 'Disabled'"
  description   = "Basic Authentication provides the ability to create identities and authentication for an App Service without a centralized Identity Provider. For a more effective, capable, and secure solution for Identity, Authentication, Authorization, and Accountability, a centralized Identity Provider such as Entra ID is strongly advised."
  documentation = file("./cis_v300/docs/cis_v300_9_6.md")

  tags = {
    folder = "CIS v3.0.0/9 App Service"
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
    text     = "9.6 Ensure that 'Basic Authentication' is 'Disabled'"
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

pipeline "cis_v300_9_7" {
  title         = "9.7 Ensure that 'PHP version' is currently supported (if in use)"
  description   = "Periodically, older versions of PHP may be deprecated and no longer supported. Using a supported version of PHP for app services is recommended to avoid potential unpatched vulnerabilities."
  documentation = file("./cis_v300/docs/cis_v300_9_7.md")

  tags = {
    folder = "CIS v3.0.0/9 App Service"
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
    text     = "9.7 Ensure that 'PHP version' is currently supported (if in use)"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_appservice_web_apps_not_using_latest_php_version

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_9_8" {
  title         = "9.8 Ensure that 'Python version' is currently supported (if in use)"
  description   = "Periodically, older versions of Python may be deprecated and no longer supported. Using a supported version of Python for app services is recommended to avoid potential unpatched vulnerabilities."
  documentation = file("./cis_v300/docs/cis_v300_9_8.md")

  tags = {
    folder = "CIS v3.0.0/9 App Service"
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
    text     = "9.8 Ensure that 'Python version' is currently supported (if in use)"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_appservice_web_apps_not_using_latest_python_version

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_9_9" {
  title         = "9.9 Ensure that 'Java version' is currently supported (if in use)"
  description   = "Periodically, newer versions are released for Java software either due to security flaws or to include additional functionality. Using the latest Java version for web apps is recommended in order to take advantage of security fixes, if any, and/or new functionalities of the newer version."
  documentation = file("./cis_v300/docs/cis_v300_9_9.md")

  tags = {
    folder = "CIS v3.0.0/9 App Service"
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
    text     = "9.9 Ensure that 'Java version' is currently supported (if in use)"
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

pipeline "cis_v300_9_10" {
  title         = "9.10 Ensure that 'HTTP20enabled' is set to 'true' (if in use)"
  description   = "Periodically, newer versions are released for HTTP either due to security flaws or to include additional functionality. Using the latest HTTP version for apps to take advantage of security fixes, if any, and/or new functionalities of the newer version."
  documentation = file("./cis_v300/docs/cis_v300_9_10.md")

  tags = {
    folder = "CIS v3.0.0/9 App Service"
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
    text     = "9.10 Ensure that 'HTTP20enabled' is set to 'true' (if in use)"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_appservice_web_apps_not_using_latest_http_version

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_9_11" {
  title         = "9.11 Ensure Azure Key Vaults are Used to Store Secrets"
  description   = "Azure Key Vault will store multiple types of sensitive information such as encryption keys, certificate thumbprints, and Managed Identity Credentials. Access to these 'Secrets' can be controlled through granular permissions."
  documentation = file("./cis_v300/docs/cis_v300_9_11.md")

  tags = {
    folder = "CIS v3.0.0/9 App Service"
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
    text     = "9.11 Ensure Azure Key Vaults are Used to Store Secrets"
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

pipeline "cis_v300_9_12" {
  title         = "9.11 Ensure that 'Remote debugging' is set to 'Off'"
  description   = "Remote Debugging allows Azure App Service to be debugged in real-time directly on the Azure environment. When remote debugging is enabled, it opens a communication channel that could potentially be exploited by unauthorized users if not properly secured."
  documentation = file("./cis_v300/docs/cis_v300_9_12.md")

  tags = {
    folder = "CIS v3.0.0/9 App Service"
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
    text     = "9.12 Ensure that 'Remote debugging' is set to 'Off'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_appservice_web_apps_with_remote_debugging_enabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}