locals {
  cis_v300_6_control_mapping = {
    cis_v300_6_1_1   = pipeline.cis_v300_6_1_1
    cis_v300_6_1_2   = pipeline.cis_v300_6_1_2
    cis_v300_6_1_3   = pipeline.cis_v300_6_1_3
    cis_v300_6_1_4   = pipeline.cis_v300_6_1_4
    cis_v300_6_1_5   = pipeline.cis_v300_6_1_5
    cis_v300_6_1_6   = pipeline.cis_v300_6_1_6
    cis_v300_6_2_1   = pipeline.cis_v300_6_2_1
		cis_v300_6_2_2   = pipeline.cis_v300_6_2_2
		cis_v300_6_2_3   = pipeline.cis_v300_6_2_3
		cis_v300_6_2_4   = pipeline.cis_v300_6_2_4
		cis_v300_6_2_5   = pipeline.cis_v300_6_2_5
		cis_v300_6_2_6   = pipeline.cis_v300_6_2_6
		cis_v300_6_2_7   = pipeline.cis_v300_6_2_7
		cis_v300_6_2_8   = pipeline.cis_v300_6_2_8
		cis_v300_6_2_9   = pipeline.cis_v300_6_2_9
		cis_v300_6_2_10  = pipeline.cis_v300_6_2_10
		cis_v300_6_3_1   = pipeline.cis_v300_6_3_1
		cis_v300_6_4     = pipeline.cis_v300_6_4
		cis_v300_6_5     = pipeline.cis_v300_6_5
  }
}

locals {
  cis_v300_6_5_pipelines = [
    azure_compliance.pipeline.detect_and_correct_network_lbs_with_basic_sku,
    azure_compliance.pipeline.detect_and_correct_network_public_ips_with_basic_sku,
		azure_compliance.pipeline.detect_and_correct_redis_caches_with_basic_sku
  ]
}

pipeline "cis_v300_6" {
  title         = "6 Logging and Monitoring"
  description   = "This section contains recommendations for configuring Azure Logging and Monitoring."
  documentation = file("./cis_v300/docs/cis_v300_6.md")

  tags = {
    folder = "CIS v3.0.0/6 Logging and Monitoring"
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
    text     = "6 Logging and Monitoring"
  }

  step "pipeline" "cis_v300_6" {
    depends_on = [step.message.header]

    loop {
      until = loop.index >= (length(keys(local.cis_v300_6_control_mapping)) - 1)
    }

    pipeline = local.cis_v300_6_control_mapping[keys(local.cis_v300_6_control_mapping)[loop.index]]

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_6_1_1" {
  title         = "6.1.1 Ensure that a 'Diagnostic Setting' exists for Subscription Activity Logs"
  description   = "Enable Diagnostic settings for exporting activity logs. Diagnostic settings are available for each individual resource within a subscription. Settings should be configured for all appropriate resources for your environment."
  documentation = file("./cis_v300/docs/cis_v300_6_1_1.md")

  tags = {
    folder = "CIS v3.0.0/6 Logging and Monitoring/6.1 Configuring Diagnostic Settings"
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
    text     = "6.1.1 Ensure that a 'Diagnostic Setting' exists for Subscription Activity Logs"
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

pipeline "cis_v300_6_1_2" {
  title         = "6.1.2 Ensure Diagnostic Setting captures appropriate categories"
  description   = "A Diagnostic Setting must exist. If a Diagnostic Setting does not exist, the navigation and options within this recommendation will not be available. Please review the recommendation at the beginning of this subsection titled: 'Ensure that a 'Diagnostic Setting' exists.' The diagnostic setting should be configured to log the appropriate activities from the control/management plane."
  documentation = file("./cis_v300/docs/cis_v300_6_1_2.md")

  tags = {
    folder = "CIS v3.0.0/6 Logging and Monitoring/6.1 Configuring Diagnostic Settings"
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
    text     = "6.1.2 Ensure Diagnostic Setting captures appropriate categories"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_subscriptions_diagnostic_setting_without_capturing_proper_categories

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_6_1_3" {
  title         = "6.1.3 Ensure the storage account containing the container with activity logs is encrypted with Customer Managed Key"
  description   = "Storage accounts with the activity log exports can be configured to use Customer Managed Keys (CMK)."
  documentation = file("./cis_v300/docs/cis_v300_6_1_3.md")

  tags = {
    folder = "CIS v3.0.0/6 Logging and Monitoring/6.1 Configuring Diagnostic Settings"
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
    text     = "6.1.3 Ensure the storage account containing the container with activity logs is encrypted with Customer Managed Key"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_monitor_storage_containers_insights_activity_logs_not_encrypted_with_cmk

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_6_1_4" {
  title         = "6.1.4 Ensure that logging for Azure Key Vault is 'Enabled'"
  description   = "Enable AuditEvent logging for key vault instances to ensure interactions with key vaults are logged and available."
  documentation = file("./cis_v300/docs/cis_v300_6_1_4.md")

  tags = {
    folder = "CIS v3.0.0/6 Logging and Monitoring/6.1 Configuring Diagnostic Settings"
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
    text     = "6.1.4 Ensure that logging for Azure Key Vault is 'Enabled'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_keyvault_vaults_with_logging_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_6_1_5" {
  title         = "6.1.5 Ensure that Network Security Group Flow logs are captured and sent to Log Analytics"
  description   = "Ensure that network flow logs are captured and fed into a central log analytics workspace."
  documentation = file("./cis_v300/docs/cis_v300_6_1_5.md")

  tags = {
    folder = "CIS v3.0.0/6 Logging and Monitoring/6.1 Configuring Diagnostic Settings"
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
    text     = "6.1.5 Ensure that Network Security Group Flow logs are captured and sent to Log Analytics"
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

pipeline "cis_v300_6_1_6" {
  title         = "6.1.6 Ensure that logging for Azure AppService 'HTTP logs' is enabled"
  description   = "Enable AppServiceHTTPLogs diagnostic log category for Azure App Service instances to ensure all http requests are captured and centrally logged."
  documentation = file("./cis_v300/docs/cis_v300_6_1_6.md")

  tags = {
    folder = "CIS v3.0.0/6 Logging and Monitoring/6.1 Configuring Diagnostic Settings"
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
    text     = "6.1.6 Ensure that logging for Azure AppService 'HTTP logs' is enabled"
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

pipeline "cis_v300_6_2_1" {
  title         = "6.2.1 Ensure that Activity Log Alert exists for Create Policy Assignment"
  description   = "Create an activity log alert for the Create Policy Assignment event."
  documentation = file("./cis_v300/docs/cis_v300_6_2_1.md")

  tags = {
    folder = "CIS v3.0.0/6 Logging and Monitoring/6.2 Monitoring using Activity Log Alerts"
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
    text     = "6.2.1 Ensure that Activity Log Alert exists for Create Policy Assignment"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_subscriptions_without_activity_log_alert_for_create_policy_assignment

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_6_2_2" {
  title         = "6.2.2 Ensure that Activity Log Alert exists for Delete Policy Assignment"
  description   = "Create an activity log alert for the Delete Policy Assignment event."
  documentation = file("./cis_v300/docs/cis_v300_6_2_2.md")

  tags = {
    folder = "CIS v3.0.0/6 Logging and Monitoring/6.2 Monitoring using Activity Log Alerts"
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
    text     = "6.2.2 Ensure that Activity Log Alert exists for Delete Policy Assignment"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_subscriptions_without_activity_log_alert_for_delete_policy_assignment

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_6_2_3" {
  title         = "6.2.3 Ensure that Activity Log Alert exists for Create or Update Network Security Group"
  description   = "Create an Activity Log Alert for the Create or Update Network Security Group event."
  documentation = file("./cis_v300/docs/cis_v300_6_2_3.md")

  tags = {
    folder = "CIS v3.0.0/6 Logging and Monitoring/6.2 Monitoring using Activity Log Alerts"
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
    text     = "6.2.3 Ensure that Activity Log Alert exists for Create or Update Network Security Group"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_subscriptions_without_activity_log_alert_for_create_update_nsg

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_6_2_4" {
  title         = "6.2.4 Ensure that Activity Log Alert exists for Delete Network Security Group"
  description   = "Create an activity log alert for the Delete Network Security Group event."
  documentation = file("./cis_v300/docs/cis_v300_6_2_4.md")

  tags = {
    folder = "CIS v3.0.0/6 Logging and Monitoring/6.2 Monitoring using Activity Log Alerts"
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
    text     = "6.2.4 Ensure that Activity Log Alert exists for Delete Network Security Group"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_subscriptions_without_activity_log_alert_for_delete_nsg

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_6_2_5" {
  title         = "6.2.5 Ensure that Activity Log Alert exists for Create or Update Security Solution"
  description   = "Create an activity log alert for the Create or Update Security Solution event."
  documentation = file("./cis_v300/docs/cis_v300_6_2_5.md")

  tags = {
    folder = "CIS v3.0.0/6 Logging and Monitoring/6.2 Monitoring using Activity Log Alerts"
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
    text     = "6.2.5 Ensure that Activity Log Alert exists for Create or Update Security Solution"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_subscriptions_without_activity_log_alert_for_create_update_security_solution

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_6_2_6" {
  title         = "6.2.6 Ensure that Activity Log Alert exists for Delete Security Solution"
  description   = "Create an activity log alert for the Delete Security Solution event."
  documentation = file("./cis_v300/docs/cis_v300_6_2_6.md")

  tags = {
    folder = "CIS v3.0.0/6 Logging and Monitoring/6.2 Monitoring using Activity Log Alerts"
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
    text     = "6.2.6 Ensure that Activity Log Alert exists for Delete Security Solution"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_subscriptions_without_activity_log_alert_for_delete_security_solution

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_6_2_7" {
  title         = "6.2.7 Ensure that Activity Log Alert exists for Create or Update SQL Server Firewall Rule"
  description   = "Create an activity log alert for the Create or Update SQL Server Firewall Rule event."
  documentation = file("./cis_v300/docs/cis_v300_6_2_7.md")

  tags = {
    folder = "CIS v3.0.0/6 Logging and Monitoring/6.2 Monitoring using Activity Log Alerts"
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
    text     = "6.2.7 Ensure that Activity Log Alert exists for Create or Update SQL Server Firewall Rule"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_subscriptions_without_activity_log_alert_for_create_update_sql_servers_firewall_rule

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_6_2_8" {
  title         = "6.2.8 Ensure that Activity Log Alert exists for Delete SQL Server Firewall Rule"
  description   = "Create an activity log alert for the 'Delete SQL Server Firewall Rule.'"
  documentation = file("./cis_v300/docs/cis_v300_6_2_8.md")

  tags = {
    folder = "CIS v3.0.0/6 Logging and Monitoring/6.2 Monitoring using Activity Log Alerts"
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
    text     = "6.2.8 Ensure that Activity Log Alert exists for Delete SQL Server Firewall Rule"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_subscriptions_without_activity_log_alert_for_delete_sql_servers_firewall_rule

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_6_2_9" {
  title         = "6.2.9 Ensure that Activity Log Alert exists for Create or Update Public IP Address rule"
  description   = "Create an activity log alert for the Create or Update Public IP Addresses rule."
  documentation = file("./cis_v300/docs/cis_v300_6_2_9.md")

  tags = {
    folder = "CIS v3.0.0/6 Logging and Monitoring/6.2 Monitoring using Activity Log Alerts"
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
    text     = "6.2.9 Ensure that Activity Log Alert exists for Create or Update Public IP Address rule"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_subscriptions_without_activity_log_alert_for_update_public_ip_address

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_6_2_10" {
  title         = "6.2.10 Ensure that Activity Log Alert exists for Delete Public IP Address rule"
  description   = "Create an activity log alert for the Delete Public IP Address rule."
  documentation = file("./cis_v300/docs/cis_v300_6_2_10.md")

  tags = {
    folder = "CIS v3.0.0/6 Logging and Monitoring/6.2 Monitoring using Activity Log Alerts"
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
    text     = "6.2.10 Ensure that Activity Log Alert exists for Delete Public IP Address rule"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_subscriptions_without_activity_log_alert_for_update_public_ip_address

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_6_3_1" {
  title         = "6.3.1 Ensure Application Insights are Configured"
  description   = "Application Insights within Azure act as an Application Performance Monitoring solution providing valuable data into how well an application performs and additional information when performing incident response. The types of log data collected include application metrics, telemetry data, and application trace logging data providing organizations with detailed information about application activity and application transactions."
  documentation = file("./cis_v300/docs/cis_v300_6_3_1.md")

  tags = {
    folder = "CIS v3.0.0/6 Logging and Monitoring/6.3 Configuring Application Insights"
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
    text     = "6.3.1 Ensure Application Insights are Configured"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_subscriptions_without_application_insight_configured

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_6_4" {
  title         = "6.4 Ensure that Azure Monitor Resource Logging is Enabled for All Services that Support it"
  description   = "Resource Logs capture activity to the data access plane while the Activity log is a subscription-level log for the control plane. Resource-level diagnostic logs provide insight into operations that were performed within that resource itself; for example, reading or updating a secret from a Key Vault."
  documentation = file("./cis_v300/docs/cis_v300_6_4.md")

  tags = {
    folder = "CIS v3.0.0/6 Logging and Monitoring"
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
    text     = "6.4 Ensure that Azure Monitor Resource Logging is Enabled for All Services that Support it"
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

pipeline "cis_v300_6_5" {
  title         = "6.5 Ensure that SKU Basic/Consumption is not used on artifacts that need to be monitored (Particularly for Production Workloads)"
  description   = "The use of Basic or Free SKUs in Azure whilst cost effective have significant limitations in terms of what can be monitored and what support can be realized from Microsoft. Typically, these SKU's do not have a service SLA and Microsoft will usually refuse to provide support for them. Consequently Basic/Free SKUs should never be used for production workloads."
  documentation = file("./cis_v300/docs/cis_v300_6_5.md")

  tags = {
    folder = "CIS v3.0.0/6 Logging and Monitoring"
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
    text     = "6.5 Ensure that SKU Basic/Consumption is not used on artifacts that need to be monitored (Particularly for Production Workloads)"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]

    loop {
      until = loop.index >= (length(local.cis_v300_6_5_pipelines) - 1)
    }

    pipeline = local.cis_v300_6_5_pipelines[loop.index]

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}