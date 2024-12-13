locals {
  cis_v300_3_control_mapping = {
    cis_v300_3_1_1_1   = pipeline.cis_v300_3_1_1_1
    cis_v300_3_1_1_2   = pipeline.cis_v300_3_1_1_2
    cis_v300_3_1_3_1   = pipeline.cis_v300_3_1_3_1
    cis_v300_3_1_3_2   = pipeline.cis_v300_3_1_3_2
    cis_v300_3_1_3_3   = pipeline.cis_v300_3_1_3_3
    cis_v300_3_1_3_4   = pipeline.cis_v300_3_1_3_4
    cis_v300_3_1_3_5   = pipeline.cis_v300_3_1_3_5
    cis_v300_3_1_4_1   = pipeline.cis_v300_3_1_4_1
		cis_v300_3_1_4_2   = pipeline.cis_v300_3_1_4_2
		cis_v300_3_1_4_3  = pipeline.cis_v300_3_1_4_3
    cis_v300_3_1_5_1  = pipeline.cis_v300_3_1_5_1
    cis_v300_3_1_6_1  = pipeline.cis_v300_3_1_6_1
		cis_v300_3_1_7_1  = pipeline.cis_v300_3_1_7_1
		cis_v300_3_1_7_2  = pipeline.cis_v300_3_1_7_2
		cis_v300_3_1_7_3  = pipeline.cis_v300_3_1_7_3
		cis_v300_3_1_7_4  = pipeline.cis_v300_3_1_7_4
		cis_v300_3_1_8_1  = pipeline.cis_v300_3_1_8_1
		cis_v300_3_1_9_1  = pipeline.cis_v300_3_1_9_1
		cis_v300_3_1_10  = pipeline.cis_v300_3_1_10
		cis_v300_3_1_11  = pipeline.cis_v300_3_1_11
		cis_v300_3_1_12  = pipeline.cis_v300_3_1_12
		cis_v300_3_1_13  = pipeline.cis_v300_3_1_13
		cis_v300_3_1_14  = pipeline.cis_v300_3_1_14
		cis_v300_3_1_15  = pipeline.cis_v300_3_1_15
		cis_v300_3_1_16  = pipeline.cis_v300_3_1_16
		cis_v300_3_2_1   = pipeline.cis_v300_3_2_1
		cis_v300_3_3_1   = pipeline.cis_v300_3_3_1
		cis_v300_3_3_2   = pipeline.cis_v300_3_3_2
		cis_v300_3_3_3   = pipeline.cis_v300_3_3_3
		cis_v300_3_3_4   = pipeline.cis_v300_3_3_4
		cis_v300_3_3_5   = pipeline.cis_v300_3_3_5
		cis_v300_3_3_6   = pipeline.cis_v300_3_3_6
		cis_v300_3_3_7   = pipeline.cis_v300_3_3_7
		cis_v300_3_3_8  = pipeline.cis_v300_3_3_8
  }
}

pipeline "cis_v300_3" {
  title         = "3 Security"
  description   = "This section contains recommendations for configuring Azure Security."
  documentation = file("./cis_v300/docs/cis_v300_3.md")

  tags = {
    folder = "CIS v3.0.0/3 Security"
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
    text     = "3 Security"
  }

  step "pipeline" "cis_v300_3" {
    depends_on = [step.message.header]

    loop {
      until = loop.index >= (length(keys(local.cis_v300_3_control_mapping)) - 1)
    }

    pipeline = local.cis_v300_3_control_mapping[keys(local.cis_v300_3_control_mapping)[loop.index]]

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_3_1_1_1" {
  title         = "3.1.1.1 Ensure that Auto provisioning of 'Log Analytics agent for Azure VMs' is Set to 'On'"
  description   = "Enable automatic provisioning of the monitoring agent to collect security data."
  documentation = file("./cis_v300/docs/cis_v300_3_1_1_1.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.1 Microsoft Defender for Cloud/3.1.1 Microsoft Cloud Security Posture Management (CSPM)"
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
    text     = "3.1.1.1 Ensure that Auto provisioning of 'Log Analytics agent for Azure VMs' is Set to 'On'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_securitycenters_with_automatic_provisioning_monitoring_agent_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_3_1_1_2" {
  title         = "3.1.1.2 Ensure that Microsoft Defender for Cloud Apps integration with Microsoft Defender for Cloud is Selected"
  description   = "This integration setting enables Microsoft Defender for Cloud Apps (formerly 'Microsoft Cloud App Security' or 'MCAS' - see additional info) to communicate with Microsoft Defender for Cloud."
  documentation = file("./cis_v300/docs/cis_v300_3_1_1_2.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.1 Microsoft Defender for Cloud/3.1.1 Microsoft Cloud Security Posture Management (CSPM)"
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
    text     = "3.1.1.2 Ensure that Microsoft Defender for Cloud Apps integration with Microsoft Defender for Cloud is Selected"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_securitycenter_settings_without_mcas_integration

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_3_1_3_1" {
  title         = "3.1.3.1 Ensure That Microsoft Defender for Servers Is Set to 'On'"
  description   = "Turning on Microsoft Defender for Servers enables threat detection for Servers, providing threat intelligence, anomaly detection, and behavior analytics in the Microsoft Defender for Cloud."
  documentation = file("./cis_v300/docs/cis_v300_3_1_3_1.md")

  tags = {
		folder = "CIS v3.0.0/3 Security/3.1 Microsoft Defender for Cloud/3.1.3 Defender Plan: Servers"
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
    text     = "3.1.3.1 Ensure That Microsoft Defender for Servers Is Set to 'On'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_securitycenters_with_azure_defender_for_server_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_3_1_3_2" {
  title         = "3.1.3.2 Ensure that 'Vulnerability assessment for machines' component status is set to 'On'"
  description   = "Enable vulnerability assessment for machines on both Azure and hybrid (Arc enabled) machines."
  documentation = file("./cis_v300/docs/cis_v300_3_1_3_2.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.1 Microsoft Defender for Cloud/3.1.3 Defender Plan: Servers"
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
    text     = "3.1.3.2 Ensure that 'Vulnerability assessment for machines' component status is set to 'On'"
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

pipeline "cis_v300_3_1_3_3" {
  title         = "3.1.3.3 Ensure that 'Endpoint protection' component status is set to 'On'"
  description   = "The Endpoint protection component enables Microsoft Defender for Endpoint (formerly 'Advanced Threat Protection' or 'ATP' or 'WDATP' - see additional info) to communicate with Microsoft Defender for Cloud."
  documentation = file("./cis_v300/docs/cis_v300_3_1_3_3.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.1 Microsoft Defender for Cloud/3.1.3 Defender Plan: Servers"
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
    text     = "3.1.3.3 Ensure that 'Endpoint protection' component status is set to 'On'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_securitycenter_settings_without_wdatp_integration

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_3_1_3_4" {
  title         = "3.1.3.4 Ensure that 'Agentless scanning for machines' component status is set to 'On'"
  description   = "Using disk snapshots, the agentless scanner scans for installed software, vulnerabilities, and plain text secrets."
  documentation = file("./cis_v300/docs/cis_v300_3_1_3_4.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.1 Microsoft Defender for Cloud/3.1.3 Defender Plan: Servers"
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
    text     = "3.1.3.4 Ensure that 'Agentless scanning for machines' component status is set to 'On'"
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

pipeline "cis_v300_3_1_3_5" {
  title         = "3.1.3.5 Ensure that 'File Integrity Monitoring' component status is set to 'On'"
  description   = "File Integrity Monitoring (FIM) is a feature that monitors critical system files in Windows or Linux for potential signs of attack or compromise."
  documentation = file("./cis_v300/docs/cis_v300_3_1_3_5.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.1 Microsoft Defender for Cloud/3.1.3 Defender Plan: Servers"
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
    text     = "3.1.3.5 Ensure that 'File Integrity Monitoring' component status is set to 'On'"
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

pipeline "cis_v300_3_1_4_1" {
  title         = "3.1.4.1 Ensure That Microsoft Defender for Containers Is Set To 'On'"
  description   = "Turning on Microsoft Defender for Containers enables threat detection for Container Registries including Kubernetes, providing threat intelligence, anomaly detection, and behavior analytics in the Microsoft Defender for Cloud."
  documentation = file("./cis_v300/docs/cis_v300_3_1_4_1.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.1 Microsoft Defender for Cloud/3.1.4 Defender Plan: Containers"
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
    text     = "3.1.4.1 Ensure That Microsoft Defender for Containers Is Set To 'On'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_securitycenters_with_azure_defender_for_container_registry_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_3_1_4_2" {
  title         = "3.1.4.2 Ensure that 'Agentless discovery for Kubernetes' component status 'On'"
  description   = "Enable automatic discovery and configuration scanning of the Microsoft Kubernetes clusters."
  documentation = file("./cis_v300/docs/cis_v300_3_1_4_2.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.1 Microsoft Defender for Cloud/3.1.4 Defender Plan: Containers"
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
    text     = "3.1.4.2 Ensure that 'Agentless discovery for Kubernetes' component status 'On'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_securitycenters_with_azure_defender_for_container_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
			approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_3_1_4_3" {
  title         = "3.1.4.3 Ensure that 'Agentless container vulnerability assessment' component status is 'On'"
  description   = "Enable automatic vulnerability management for images stored in ACR or running in AKS clusters."
  documentation = file("./cis_v300/docs/cis_v300_3_1_4_3.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.1 Microsoft Defender for Cloud/3.1.4 Defender Plan: Containers"
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
    text     = "3.1.4.3 Ensure that 'Agentless container vulnerability assessment' component status is 'On'"
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

pipeline "cis_v300_3_1_5_1" {
  title         = "3.1.5.1 Ensure That Microsoft Defender for Storage Is Set To 'On'"
  description   = "Turning on Microsoft Defender for Storage enables threat detection for Storage, providing threat intelligence, anomaly detection, and behavior analytics in the Microsoft Defender for Cloud."
  documentation = file("./cis_v300/docs/cis_v300_3_1_5_1.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.1 Microsoft Defender for Cloud/3.1.5 Defender Plan: Storage"
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
    text     = "3.1.5.1 Ensure That Microsoft Defender for Storage Is Set To 'On'"
	}

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_securitycenters_with_azure_defender_for_storage_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_3_1_6_1" {
  title         = "3.1.6.1 Ensure That Microsoft Defender for App Services Is Set To 'On'"
  description   = "Turning on Microsoft Defender for App Service enables threat detection for App Service, providing threat intelligence, anomaly detection, and behavior analytics in the Microsoft Defender for Cloud."
  documentation = file("./cis_v300/docs/cis_v300_3_1_6_1.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.1 Microsoft Defender for Cloud/3.1.6 Defender Plan: App Service"
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
    text     = "3.1.6.1 Ensure That Microsoft Defender for App Services Is Set To 'On'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_securitycenters_with_azure_defender_for_app_service_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_3_1_7_1" {
  title         = "3.1.7.1 Ensure That Microsoft Defender for Azure Cosmos DB Is Set To 'On'"
  description   = "Microsoft Defender for Azure Cosmos DB scans all incoming network requests for threats to your Azure Cosmos DB resources."
  documentation = file("./cis_v300/docs/cis_v300_3_1_7_1.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.1 Microsoft Defender for Cloud/3.1.7 Defender Plan: Databases"
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
    text     = "3.1.7.1 Ensure That Microsoft Defender for Azure Cosmos DB Is Set To 'On'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_securitycenters_with_azure_defender_for_cosmosdb_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_3_1_7_2" {
  title         = "3.1.7.2 Ensure That Microsoft Defender for Open-Source Relational Databases Is Set To 'On'"
  description   = "Turning on Microsoft Defender for Open-source relational databases enables threat detection for Open-source relational databases, providing threat intelligence, anomaly detection, and behavior analytics in the Microsoft Defender for Cloud."
  documentation = file("./cis_v300/docs/cis_v300_3_1_7_2.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.1 Microsoft Defender for Cloud/3.1.7 Defender Plan: Databases"
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
    text     = "3.1.7.2 Ensure That Microsoft Defender for Open-Source Relational Databases Is Set To 'On'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_securitycenters_with_azure_defender_for_open_source_relational_db_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_3_1_7_3" {
  title         = "3.1.7.3 Ensure That Microsoft Defender for (Managed Instance) Azure SQL Databases Is Set To 'On'"
  description   = "Turning on Microsoft Defender for Azure SQL Databases enables threat detection for Azure SQL database servers, providing threat intelligence, anomaly detection, and behavior analytics in the Microsoft Defender for Cloud."
  documentation = file("./cis_v300/docs/cis_v300_3_1_7_3.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.1 Microsoft Defender for Cloud/3.1.7 Defender Plan: Databases"
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
    text     = "3.1.7.3 Ensure That Microsoft Defender for (Managed Instance) Azure SQL Databases Is Set To 'On'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_securitycenters_with_azure_defender_for_sql_db_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_3_1_7_4" {
  title         = "3.1.7.4 Ensure That Microsoft Defender for SQL Servers on Machines Is Set To 'On'"
  description   = "Turning on Microsoft Defender for SQL servers on machines enables threat detection for SQL servers on machines, providing threat intelligence, anomaly detection, and behavior analytics in the Microsoft Defender for Cloud."
  documentation = file("./cis_v300/docs/cis_v300_3_1_7_4.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.1 Microsoft Defender for Cloud/3.1.7 Defender Plan: Databases"
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
    text     = "3.1.7.4 Ensure That Microsoft Defender for SQL Servers on Machines Is Set To 'On'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_securitycenters_with_azure_defender_for_sql_server_vm_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_3_1_8_1" {
  title         = "3.1.8.1 Ensure That Microsoft Defender for Key Vault Is Set To 'On'"
  description   = "Turning on Microsoft Defender for Key Vault enables threat detection for Key Vault, providing threat intelligence, anomaly detection, and behavior analytics in the Microsoft Defender for Cloud."
  documentation = file("./cis_v300/docs/cis_v300_3_1_8_1.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.1 Microsoft Defender for Cloud/3.1.8 Defender Plan: Key Vault"
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
    text     = "3.1.8.1 Ensure That Microsoft Defender for Key Vault Is Set To 'On'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_securitycenters_with_azure_defender_for_keyvault_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_3_1_9_1" {
  title         = "3.1.9.1 Ensure That Microsoft Defender for Resource Manager Is Set To 'On'"
  description   = "Microsoft Defender for Resource Manager scans incoming administrative requests to change your infrastructure from both CLI and the Azure portal."
  documentation = file("./cis_v300/docs/cis_v300_3_1_9_1.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.1 Microsoft Defender for Cloud/3.1.9 Defender Plan: Resource Manager"
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
    text     = "3.1.9.1 Ensure That Microsoft Defender for Resource Manager Is Set To 'On'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_securitycenters_with_azure_defender_for_resource_manager_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_3_1_10" {
  title         = "3.1.10 Ensure that Microsoft Defender Recommendation for 'Apply system updates' status is 'Completed'"
  description   = "Ensure that the latest OS patches for all virtual machines are applied."
  documentation = file("./cis_v300/docs/cis_v300_3_1_10.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.1 Microsoft Defender for Cloud"
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
    text     = "3.1.10 Ensure that Microsoft Defender Recommendation for 'Apply system updates' status is 'Completed'"
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

pipeline "cis_v300_3_1_11" {
  title         = "3.1.11 Ensure that Microsoft Cloud Security Benchmark policies are not set to 'Disabled'"
  description   = "The Microsoft Cloud Security Benchmark (or 'MCSB') is an Azure Policy Initiative containing many security policies to evaluate resource configuration against best practice recommendations. If a policy in the MCSB is set with effect type Disabled, it is not evaluated and may prevent administrators from being informed of valuable security recommendations."
  documentation = file("./cis_v300/docs/cis_v300_3_1_11.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.1 Microsoft Defender for Cloud"
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
    text     = "3.1.11 Ensure that Microsoft Cloud Security Benchmark policies are not set to 'Disabled'"
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

pipeline "cis_v300_3_1_12" {
  title         = "3.1.12 Ensure That 'All users with the following roles' is set to 'Owner'"
  description   = "Enable security alert emails to subscription owners."
  documentation = file("./cis_v300/docs/cis_v300_3_1_11.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.1 Microsoft Defender for Cloud"
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
    text     = "3.1.12 Ensure That 'All users with the following roles' is set to 'Owner'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_securitycenters_with_security_alerts_to_owner_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_3_1_13" {
  title         = "3.1.13 Ensure 'Additional email addresses' is Configured with a Security Contact Email"
  description   = "Microsoft Defender for Cloud emails the subscription owners whenever a high-severity alert is triggered for their subscription. You should provide a security contact email address as an additional email address."
  documentation = file("./cis_v300/docs/cis_v300_3_1_13.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.1 Microsoft Defender for Cloud"
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
    text     = "3.1.13 Ensure 'Additional email addresses' is Configured with a Security Contact Email"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_securitycenters_without_additional_email_configured

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_3_1_14" {
  title         = "3.1.14 Ensure That 'Notify about alerts with the following severity' is Set to 'High'"
  description   = "Enables emailing security alerts to the subscription owner or other designated security contact."
  documentation = file("./cis_v300/docs/cis_v300_3_1_14.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.1 Microsoft Defender for Cloud"
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
    text     = "3.1.14 Ensure That 'Notify about alerts with the following severity' is Set to 'High'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_securitycenters_without_notify_alerts_configured

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_3_1_15" {
  title         = "3.1.15 Ensure that Microsoft Defender External Attack Surface Monitoring (EASM) is enabled"
  description   = "An organization's attack surface is the collection of assets with a public network identifier or URI that an external threat actor can see or access from outside your cloud. It is the set of points on the boundary of a system, a system element, system component, or an environment where an attacker can try to enter, cause an effect on, or extract data from, that system, system element, system component, or environment. The larger the attack surface, the harder it is to protect."
  documentation = file("./cis_v300/docs/cis_v300_3_1_15.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.1 Microsoft Defender for Cloud"
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
    text     = "3.1.15 Ensure that Microsoft Defender External Attack Surface Monitoring (EASM) is enabled"
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

pipeline "cis_v300_3_1_16" {
  title         = "3.1.16 [LEGACY] Ensure That Microsoft Defender for DNS Is Set To 'On'"
  description   = "Microsoft Defender for DNS scans all network traffic exiting from within a subscription."
  documentation = file("./cis_v300/docs/cis_v300_3_1_16.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.1 Microsoft Defender for Cloud"
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
    text     = "3.1.16 [LEGACY] Ensure That Microsoft Defender for DNS Is Set To 'On'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   =azure_compliance.pipeline.detect_and_correct_securitycenters_with_azure_defender_for_dns_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_3_2_1" {
  title         = "3.2.1 Ensure That Microsoft Defender for IoT Hub Is Set To 'On'"
  description   = "Microsoft Defender for IoT acts as a central security hub for IoT devices within your organization."
  documentation = file("./cis_v300/docs/cis_v300_3_2_1.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.2 Microsoft Defender for IoT"
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
    text     = "3.2.1 Ensure That Microsoft Defender for IoT Hub Is Set To 'On'"
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

pipeline "cis_v300_3_3_1" {
  title         = "3.3.1 Ensure that the Expiration Date is set for all Keys in RBAC Key Vaults"
  description   = "Ensure that all Keys in Role Based Access Control (RBAC) Azure Key Vaults have an expiration date set."
  documentation = file("./cis_v300/docs/cis_v300_3_3_1.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.3 Key Vault"
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
    text     = "3.3.1 Ensure that the Expiration Date is set for all Keys in RBAC Key Vaults"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_keyvault_with_rbac_keys_expiration_not_set

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_3_3_2" {
  title         = "3.3.2 Ensure that the Expiration Date is set for all Keys in Non-RBAC Key Vaults"
  description   = "Ensure that all Keys in Non Role Based Access Control (RBAC) Azure Key Vaults have an expiration date set."
  documentation = file("./cis_v300/docs/cis_v300_3_3_2.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.3 Key Vault"
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
    text     = "3.3.2 Ensure that the Expiration Date is set for all Keys in Non-RBAC Key Vaults"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_keyvault_with_non_rbac_keys_expiration_not_set

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_3_3_3" {
  title         = "3.3.3 Ensure that the Expiration Date is set for all Secrets in RBAC Key Vaults"
  description   = "Ensure that all Secrets in Role Based Access Control (RBAC) Azure Key Vaults have an expiration date set."
  documentation = file("./cis_v300/docs/cis_v300_3_3_3.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.3 Key Vault"
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
    text     = "3.3.3 Ensure that the Expiration Date is set for all Secrets in RBAC Key Vaults"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_keyvault_with_rbac_secrets_expiration_not_set

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_3_3_4" {
  title         = "3.3.4 Ensure that the Expiration Date is set for all Secrets in Non-RBAC Key Vaults"
  description   = "Ensure that all Secrets in Non Role Based Access Control (RBAC) Azure Key Vaults have an expiration date set."
  documentation = file("./cis_v300/docs/cis_v300_3_3_4.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.3 Key Vault"
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
    text     = "3.3.4 Ensure that the Expiration Date is set for all Secrets in Non-RBAC Key Vaults"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_keyvault_with_non_rbac_secrets_expiration_not_set

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_3_3_5" {
  title         = "3.3.5 Ensure the Key Vault is Recoverable"
  description   = "The key vault contains object keys, secrets and certificates. Accidental unavailability of a key vault can cause immediate data loss or loss of security functions (authentication, validation, verification, non-repudiation, etc.) supported by the key vault objects. It is recommended the key vault be made recoverable by enabling the \"Do Not Purge\" and \"Soft Delete\" functions."
  documentation = file("./cis_v300/docs/cis_v300_3_3_5.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.3 Key Vault"
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
    text     = "3.3.5 Ensure the Key Vault is Recoverable"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_keyvault_vaults_with_purge_protection_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_3_3_6" {
  title         = "3.3.6 Enable Role Based Access Control for Azure Key Vault"
  description   = "Role assignments disappear when a Key Vault has been deleted (soft-delete) and recovered. Afterwards it will be required to recreate all role assignments. This is a limitation of the soft-delete feature across all Azure services."
  documentation = file("./cis_v300/docs/cis_v300_3_3_6.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.3 Key Vault"
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
    text     = "3.3.6 Enable Role Based Access Control for Azure Key Vault"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_keyvault_vaults_with_rbac_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_3_3_7" {
  title         = "3.3.7 Ensure that Private Endpoints are Used for Azure Key Vault"
  description   = "Private endpoints will secure network traffic from Azure Key Vault to the resources requesting secrets and keys."
  documentation = file("./cis_v300/docs/cis_v300_3_3_7.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.3 Key Vault"
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
    text     = "3.3.7 Ensure that Private Endpoints are Used for Azure Key Vault"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_keyvault_vaults_without_private_link

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_3_3_8" {
  title         = "3.3.8 Ensure Automatic Key Rotation is Enabled Within Azure Key Vault for the Supported Services"
  description   = "Automatic Key Rotation is available in Public Preview. The currently supported applications are Key Vault, Managed Disks, and Storage accounts accessing keys within Key Vault. The number of supported applications will incrementally increased."
  documentation = file("./cis_v300/docs/cis_v300_3_3_8.md")

  tags = {
    folder = "CIS v3.0.0/3 Security/3.3 Key Vault"
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
    text     = "3.3.8 Ensure Automatic Key Rotation is Enabled Within Azure Key Vault for the Supported Services"
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
