locals {
  cis_v300_control_mapping = {
    cis_v300_2  = pipeline.cis_v300_2
    cis_v300_3  = pipeline.cis_v300_3
    cis_v300_4  = pipeline.cis_v300_4
    cis_v300_5  = pipeline.cis_v300_5
    cis_v300_6  = pipeline.cis_v300_6
    cis_v300_7  = pipeline.cis_v300_7
    cis_v300_8  = pipeline.cis_v300_8
    cis_v300_9  = pipeline.cis_v300_9
    cis_v300_10 = pipeline.cis_v300_10
  }
}

pipeline "cis_v300" {
  title         = "CIS v3.0.0"
  description   = "The CIS Microsoft Azure Foundations Security Benchmark provides prescriptive guidance for establishing a secure baseline configuration for Microsoft Azure."
  #documentation = file("./cis_v300/docs/cis_overview.md")

  tags = {
    folder      = "CIS v3.0.0"
    recommended = "true"
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
    text     = "CIS v3.0.0"
  }

  step "pipeline" "run_pipelines" {
    depends_on = [step.message.header]

    loop {
      until = loop.index >= (length(keys(local.cis_v300_control_mapping))-1)
    }

    pipeline = local.cis_v300_control_mapping[keys(local.cis_v300_control_mapping)[loop.index]]

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}
