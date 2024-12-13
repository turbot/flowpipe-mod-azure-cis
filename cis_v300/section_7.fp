locals {
  cis_v300_7_control_mapping = {
    cis_v300_7_1   = pipeline.cis_v300_7_1
    cis_v300_7_2   = pipeline.cis_v300_7_2
    cis_v300_7_3   = pipeline.cis_v300_7_3
    cis_v300_7_4   = pipeline.cis_v300_7_4
    cis_v300_7_5   = pipeline.cis_v300_7_5
    cis_v300_7_6   = pipeline.cis_v300_7_6
    cis_v300_7_7   = pipeline.cis_v300_7_7
  }
}

pipeline "cis_v300_7" {
  title         = "7 Networking"
  description   = "This section contains recommendations for configuring Azure Networking."
  documentation = file("./cis_v300/docs/cis_v300_7.md")

  tags = {
    folder = "CIS v3.0.0/7 Networking"
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
    text     = "7 Networking"
  }

  step "pipeline" "cis_v300_7" {
    depends_on = [step.message.header]

    loop {
      until = loop.index >= (length(keys(local.cis_v300_7_control_mapping)) - 1)
    }

    pipeline = local.cis_v300_7_control_mapping[keys(local.cis_v300_7_control_mapping)[loop.index]]

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_7_1" {
  title         = "7.1 Ensure that RDP access from the Internet is evaluated and restricted"
  description   = "Network security groups should be periodically evaluated for port misconfigurations. Where certain ports and protocols may be exposed to the Internet, they should be evaluated for necessity and restricted wherever they are not explicitly required."
  documentation = file("./cis_v300/docs/cis_v300_7_1.md")

  tags = {
    folder = "CIS v3.0.0/7 Networking"
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
    text     = "7.1 Ensure that RDP access from the Internet is evaluated and restricted"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_network_security_groups_allowing_inbound_to_rdp_port

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_7_2" {
  title         = "7.2 Ensure that SSH access from the Internet is evaluated and restricted"
  description   = "Network security groups should be periodically evaluated for port misconfigurations. Where certain ports and protocols may be exposed to the Internet, they should be evaluated for necessity and restricted wherever they are not explicitly required."
  documentation = file("./cis_v300/docs/cis_v300_7_2.md")

  tags = {
    folder = "CIS v3.0.0/7 Networking"
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
    text     = "7.2 Ensure that SSH access from the Internet is evaluated and restricted"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_network_security_groups_allowing_inbound_to_ssh_port

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_7_3" {
  title         = "7.3 Ensure that UDP access from the Internet is evaluated and restricted"
  description   = "Network security groups should be periodically evaluated for port misconfigurations. Where certain ports and protocols may be exposed to the Internet, they should be evaluated for necessity and restricted wherever they are not explicitly required."
  documentation = file("./cis_v300/docs/cis_v300_7_3.md")

  tags = {
    folder = "CIS v3.0.0/7 Networking"
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
    text     = "7.3 Ensure that UDP access from the Internet is evaluated and restricted"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_network_security_groups_allowing_inbound_to_udp_port

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_7_4" {
  title         = "7.4 Ensure that HTTP(S) access from the Internet is evaluated and restricted"
  description   = "Network security groups should be periodically evaluated for port misconfigurations. Where certain ports and protocols may be exposed to the Internet, they should be evaluated for necessity and restricted wherever they are not explicitly required and narrowly configured."
  documentation = file("./cis_v300/docs/cis_v300_7_4.md")

  tags = {
    folder = "CIS v3.0.0/7 Networking"
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
    text     = "7.4 Ensure that HTTP(S) access from the Internet is evaluated and restricted"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_network_security_groups_allowing_inbound_to_https_port

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_7_5" {
  title         = "7.5 Ensure that Network Security Group Flow Log retention period is 'greater than 90 days'"
  description   = "Network Security Group Flow Logs should be enabled and the retention period set to greater than or equal to 90 days."
  documentation = file("./cis_v300/docs/cis_v300_7_5.md")

  tags = {
    folder = "CIS v3.0.0/7 Networking"
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
    text     = "7.5 Ensure that Network Security Group Flow Log retention period is 'greater than 90 days'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_network_securitys_group_flow_log_with_retention_period_less_than_90_days

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_7_6" {
  title         = "7.6 Ensure that Network Watcher is 'Enabled' for Azure Regions that are in use"
  description   = "Enable Network Watcher for physical regions in Azure subscriptions."
  documentation = file("./cis_v300/docs/cis_v300_7_6.md")

  tags = {
    folder = "CIS v3.0.0/7 Networking"
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
    text     = "7.6 Ensure that Network Watcher is 'Enabled' for Azure Regions that are in use"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_network_watcher_disabled_in_regions

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_7_7" {
  title         = "7.7 Ensure that Public IP addresses are Evaluated on a Periodic Basis"
  description   = "Public IP Addresses provide tenant accounts with Internet connectivity for resources contained within the tenant. During the creation of certain resources in Azure, a Public IP Address may be created. All Public IP Addresses within the tenant should be periodically reviewed for accuracy and necessity."
  documentation = file("./cis_v300/docs/cis_v300_7_7.md")

  tags = {
    folder = "CIS v3.0.0/7 Networking"
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
    text     = "7.7 Ensure that Public IP addresses are Evaluated on a Periodic Basis"
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
