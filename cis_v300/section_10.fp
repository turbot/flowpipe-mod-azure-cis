locals {
  cis_v300_10_control_mapping = {
    cis_v300_10_1   = pipeline.cis_v300_10_1
  }
}

pipeline "cis_v300_10" {
  title         = "10 Miscellaneous"
  description   = "This section contains recommendations for configuring Azure Miscellaneous."
  documentation = file("./cis_v300/docs/cis_v300_10.md")

  tags = {
    folder = "CIS v3.0.0/10 Miscellaneous"
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
    text     = "10 Miscellaneous"
  }

  step "pipeline" "cis_v300_10" {
    depends_on = [step.message.header]

    loop {
      until = loop.index >= (length(keys(local.cis_v300_10_control_mapping)) - 1)
    }

    pipeline = local.cis_v300_10_control_mapping[keys(local.cis_v300_10_control_mapping)[loop.index]]

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_10_1" {
  title         = "10.1 Ensure that Resource Locks are set for Mission-Critical Azure Resources"
  description   = "Resource Manager Locks provide a way for administrators to lock down Azure resources to prevent deletion of, or modifications to, a resource. These locks sit outside of the Role Based Access Controls (RBAC) hierarchy and, when applied, will place restrictions on the resource for all users."
  documentation = file("./cis_v300/docs/cis_v300_10_1.md")

  tags = {
    folder = "CIS v3.0.0/10 Miscellaneous"
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
    text     = "10.1 Ensure that Resource Locks are set for Mission-Critical Azure Resources"
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