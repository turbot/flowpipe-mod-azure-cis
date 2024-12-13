locals {
  cis_v300_5_control_mapping = {
    cis_v300_5_1_1   = pipeline.cis_v300_5_1_1
    cis_v300_5_1_2   = pipeline.cis_v300_5_1_2
    cis_v300_5_1_3   = pipeline.cis_v300_5_1_3
    cis_v300_5_1_4   = pipeline.cis_v300_5_1_4
    cis_v300_5_1_5   = pipeline.cis_v300_5_1_5
    cis_v300_5_1_6   = pipeline.cis_v300_5_1_6
		cis_v300_5_1_7   = pipeline.cis_v300_5_1_7
    cis_v300_5_2_1   = pipeline.cis_v300_5_2_1
		cis_v300_5_2_2   = pipeline.cis_v300_5_2_2
		cis_v300_5_2_3   = pipeline.cis_v300_5_2_3
		cis_v300_5_2_4   = pipeline.cis_v300_5_2_4
		cis_v300_5_2_5   = pipeline.cis_v300_5_2_5
		cis_v300_5_2_6   = pipeline.cis_v300_5_2_6
		cis_v300_5_2_7   = pipeline.cis_v300_5_2_7
		cis_v300_5_2_8   = pipeline.cis_v300_5_2_8
		cis_v300_5_3_1   = pipeline.cis_v300_5_3_1
		cis_v300_5_3_2   = pipeline.cis_v300_5_3_2
		cis_v300_5_3_3   = pipeline.cis_v300_5_3_3
		cis_v300_5_3_4   = pipeline.cis_v300_5_3_4
		cis_v300_5_4_1   = pipeline.cis_v300_5_4_1
		cis_v300_5_4_2   = pipeline.cis_v300_5_4_2
		cis_v300_5_4_3   = pipeline.cis_v300_5_4_3
  }
}

pipeline "cis_v300_5" {
  title         = "5 Database Services"
  description   = "This section contains recommendations for configuring Azure Database Services."
  documentation = file("./cis_v300/docs/cis_v300_5.md")

  tags = {
    folder = "CIS v3.0.0/5 Database Services"
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
    text     = "5 Database Services"
  }

  step "pipeline" "cis_v300_5" {
    depends_on = [step.message.header]

    loop {
      until = loop.index >= (length(keys(local.cis_v300_5_control_mapping)) - 1)
    }

    pipeline = local.cis_v300_5_control_mapping[keys(local.cis_v300_5_control_mapping)[loop.index]]

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_5_1_1" {
  title         = "5.1.1 Ensure that 'Auditing' is set to 'On'"
  description   = "Enable auditing on SQL Servers."
  documentation = file("./cis_v300/docs/cis_v300_5_1_1.md")

  tags = {
    folder = "CIS v3.0.0/5 Database Services/5.1 Azure SQL Database"
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
    text     = "5.1.1 Ensure that 'Auditing' is set to 'On'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_sql_servers_with_auditing_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_5_1_2" {
  title         = "5.1.2 Ensure no Azure SQL Databases allow ingress from 0.0.0.0/0 (ANY IP)"
  description   = "Ensure that no SQL Databases allow ingress from 0.0.0.0/0 (ANY IP)."
  documentation = file("./cis_v300/docs/cis_v300_5_1_2.md")

  tags = {
    folder = "CIS v3.0.0/5 Database Services/5.1 Azure SQL Database"
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
    text     = "5.1.2 Ensure no Azure SQL Databases allow ingress from 0.0.0.0/0 (ANY IP)"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_sql_databases_with_public_access_enabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
			approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_5_1_3" {
  title         = "5.1.3 Ensure SQL server's Transparent Data Encryption (TDE) protector is encrypted with Customer-managed key"
  description   = "Transparent Data Encryption (TDE) with Customer-managed key support provides increased transparency and control over the TDE Protector, increased security with an HSM-backed external service, and promotion of separation of duties."
  documentation = file("./cis_v300/docs/cis_v300_5_1_3.md")

  tags = {
    folder = "CIS v3.0.0/5 Database Services/5.1 Azure SQL Database"
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
    text     = "5.1.3 Ensure SQL server's Transparent Data Encryption (TDE) protector is encrypted with Customer-managed key"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_sql_databases_with_transparent_data_encryption_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
			approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_5_1_4" {
  title         = "5.1.4 Ensure that Microsoft Entra authentication is Configured for SQL Servers"
  description   = "Use Azure Active Directory Authentication for authentication with SQL Database to manage credentials in a single place."
  documentation = file("./cis_v300/docs/cis_v300_5_1_4.md")

  tags = {
    folder = "CIS v3.0.0/5 Database Services/5.1 Azure SQL Database"
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
    text     = "5.1.4 Ensure that Microsoft Entra authentication is Configured for SQL Servers"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_sql_servers_without_active_directory_admin_configured

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_5_1_5" {
  title         = "5.1.5 Ensure that 'Data encryption' is set to 'On' on a SQL Database"
  description   = "Enable Transparent Data Encryption on every SQL server."
  documentation = file("./cis_v300/docs/cis_v300_5_1_5.md")

  tags = {
    folder = "CIS v3.0.0/5 Database Services/5.1 Azure SQL Database"
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
    text     = "5.1.5 Ensure that 'Data encryption' is set to 'On' on a SQL Database"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_sql_databases_with_transparent_data_encryption_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
			approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_5_1_6" {
  title         = "5.1.6 Ensure that 'Auditing' Retention is 'greater than 90 days'"
  description   = "SQL Server Audit Retention should be configured to be greater than 90 days."
  documentation = file("./cis_v300/docs/cis_v300_5_1_6.md")

  tags = {
    folder = "CIS v3.0.0/5 Database Services/5.1 Azure SQL Database"
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
    text     = "5.1.6 Ensure that 'Auditing' Retention is 'greater than 90 days'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_sql_servers_with_auditing_retention_period_less_than_90_days

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_5_1_7" {
  title         = "5.1.7 Ensure Public Network Access is Disabled"
  description   = "Disabling public network access restricts the service from accessing public networks."
  documentation = file("./cis_v300/docs/cis_v300_5_1_7.md")

  tags = {
    folder = "CIS v3.0.0/5 Database Services/5.1 Azure SQL Database"
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
    text     = "5.1.7 Ensure Public Network Access is Disabled"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_sql_servers_with_public_network_access_enabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
			approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_5_2_1" {
  title         = "5.2.1 Ensure server parameter 'require_secure_transport' is set to 'ON' for PostgreSQL flexible server"
  description   = "Enable 'require_secure_transport' on 'PostgreSQL flexible servers'."
  documentation = file("./cis_v300/docs/cis_v300_5_2_1.md")

  tags = {
    folder = "CIS v3.0.0/5 Database Services/5.2 Azure Database for PostgreSQL"
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
    text     = "5.2.1 Ensure server parameter 'require_secure_transport' is set to 'ON' for PostgreSQL flexible server"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_postgresql_flexible_servers_with_ssl_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
			approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_5_2_2" {
  title         = "5.2.2 Ensure server parameter 'log_checkpoints' is set to 'ON' for PostgreSQL flexible Server"
  description   = "Enable 'log_checkpoints' on 'PostgreSQL Servers'."
  documentation = file("./cis_v300/docs/cis_v300_5_2_2.md")

  tags = {
    folder = "CIS v3.0.0/5 Database Services/5.2 Azure Database for PostgreSQL"
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
    text     = "5.2.2 Ensure server parameter 'log_checkpoints' is set to 'ON' for PostgreSQL flexible Server"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_postgresql_flexible_servers_with_log_checkpoints_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
			approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_5_2_3" {
  title         = "5.2.3 Ensure server parameter 'connection_throttle.enable' is set to 'ON' for PostgreSQL flexible Server"
  description   = "Enable connection_throttling on PostgreSQL flexible Servers."
  documentation = file("./cis_v300/docs/cis_v300_5_2_3.md")

  tags = {
    folder = "CIS v3.0.0/5 Database Services/5.2 Azure Database for PostgreSQL"
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
    text     = "5.2.3 Ensure server parameter 'connection_throttle.enable' is set to 'ON' for PostgreSQL flexible Server"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_postgresql_flexible_servers_with_connection_throttling_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
			approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_5_2_4" {
  title         = "5.2.4 Ensure Server Parameter 'logfiles.retention_days' is greater than 3 days for PostgreSQL flexible Server"
  description   = "Ensure logfiles.retention_days on PostgreSQL flexible Servers is set to an appropriate value."
  documentation = file("./cis_v300/docs/cis_v300_5_2_4.md")

  tags = {
    folder = "CIS v3.0.0/5 Database Services/5.2 Azure Database for PostgreSQL"
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
    text     = "5.2.4 Ensure Server Parameter 'logfiles.retention_days' is greater than 3 days for PostgreSQL flexible Server"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_postgresql_servers_with_log_retention_less_than_or_equal_to_3_days

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
			approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_5_2_5" {
  title         = "5.2.5 Ensure 'Allow public access from any Azure service within Azure to this server' for PostgreSQL flexible server is disabled"
  description   = "Disable access from Azure services to PostgreSQL flexible server."
  documentation = file("./cis_v300/docs/cis_v300_5_2_5.md")

  tags = {
    folder = "CIS v3.0.0/5 Database Services/5.2 Azure Database for PostgreSQL"
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
    text     = "5.2.5 Ensure 'Allow public access from any Azure service within Azure to this server' for PostgreSQL flexible server is disabled"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_postgresql_servers_with_allow_access_to_azure_services_enabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
			approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_5_2_6" {
  title         = "5.2.6 [LEGACY]Ensure server parameter 'log_connections' is set to 'ON' for PostgreSQL single Server"
  description   = "Enable 'log_connections' on 'PostgreSQL single Servers'."
  documentation = file("./cis_v300/docs/cis_v300_5_2_6.md")

  tags = {
    folder = "CIS v3.0.0/5 Database Services/5.2 Azure Database for PostgreSQL"
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
    text     = "5.2.6 [LEGACY]Ensure server parameter 'log_connections' is set to 'ON' for PostgreSQL single Server"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_postgresql_servers_with_log_connections_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
			approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_5_2_7" {
  title         = "5.2.7 [LEGACY]Ensure server parameter 'log_disconnections' is set to 'ON' for PostgreSQL single Server"
  description   = "Enable 'log_disconnections' on 'PostgreSQL Servers'."
  documentation = file("./cis_v300/docs/cis_v300_5_2_7.md")

  tags = {
    folder = "CIS v3.0.0/5 Database Services/5.2 Azure Database for PostgreSQL"
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
    text     ="5.2.7 [LEGACY]Ensure server parameter 'log_disconnections' is set to 'ON' for PostgreSQL single Server"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_postgresql_servers_with_log_disconnections_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
			approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_5_2_8" {
  title         = "5.2.8 [LEGACY]Ensure 'Infrastructure double encryption' for PostgreSQL Database Server is 'Enabled'"
  description   = "Azure Database for PostgreSQL servers should be created with 'infrastructure double encryption' enabled."
  documentation = file("./cis_v300/docs/cis_v300_5_2_8.md")

  tags = {
    folder = "CIS v3.0.0/5 Database Services/5.2 Azure Database for PostgreSQL"
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
    text     = "5.2.8 [LEGACY]Ensure 'Infrastructure double encryption' for PostgreSQL Database Server is 'Enabled'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_postgresql_servers_with_infrastructure_encryption_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_5_3_1" {
  title         = "5.3.1 Ensure server parameter 'require_secure_transport' is set to 'ON' for MySQL flexible server"
  description   = "Enable require_secure_transport on MySQL flexible servers."
  documentation = file("./cis_v300/docs/cis_v300_5_3_1.md")

  tags = {
    folder = "CIS v3.0.0/5 Database Services/5.3 Azure Database for MySQL"
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
    text     = "5.3.1 Ensure server parameter 'require_secure_transport' is set to 'ON' for MySQL flexible server"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_mysql_flexible_servers_with_ssl_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
			approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_5_3_2" {
  title         = "5.3.2 Ensure server parameter 'tls_version' is set to 'TLSv1.2' (or higher) for MySQL flexible server"
  description   = "Ensure tls_version on MySQL flexible servers is set to use TLS version 1.2 or higher."
  documentation = file("./cis_v300/docs/cis_v300_5_3_2.md")

  tags = {
    folder = "CIS v3.0.0/5 Database Services/5.3 Azure Database for MySQL"
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
    text     = "5.3.2 Ensure server parameter 'tls_version' is set to 'TLSv1.2' (or higher) for MySQL flexible server"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_mysql_flexible_servers_with_no_min_tls_1_2

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
			approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_5_3_3" {
  title         = "5.3.3 Ensure server parameter 'audit_log_enabled' is set to 'ON' for MySQL flexible Server"
  description   = "Enable audit_log_enabled on MySQL flexible Servers."
  documentation = file("./cis_v300/docs/cis_v300_5_3_3.md")

  tags = {
    folder = "CIS v3.0.0/5 Database Services/5.3 Azure Database for MySQL"
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
    text     = "5.3.3 Ensure server parameter 'audit_log_enabled' is set to 'ON' for MySQL flexible Server"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_mysql_flexible_servers_with_audit_log_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
			approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_5_3_4" {
  title         = "5.3.4 Ensure server parameter 'audit_log_events' has 'CONNECTION' set for MySQL flexible Server"
  description   = "Set audit_log_enabled to include CONNECTION on MySQL flexible servers."
  documentation = file("./cis_v300/docs/cis_v300_5_3_4.md")

  tags = {
    folder = "CIS v3.0.0/5 Database Services/5.3 Azure Database for MySQL"
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
    text     = "5.3.4 Ensure server parameter 'audit_log_events' has 'CONNECTION' set for MySQL flexible Server"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_mysql_flexible_servers_with_audit_log_events_connection_not_set

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
			approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_5_4_1" {
  title         = "5.4.1 Ensure That 'Firewalls & Networks' Is Limited to Use Selected Networks Instead of All Networks"
  description   = "Limiting your Cosmos DB to only communicate on whitelisted networks lowers its attack footprint."
  documentation = file("./cis_v300/docs/cis_v300_5_4_1.md")

  tags = {
    folder = "CIS v3.0.0/5 Database Services/5.4 Azure Cosmos DB"
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
    text     = "5.4.1 Ensure That 'Firewalls & Networks' Is Limited to Use Selected Networks Instead of All Networks"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_cosmosdb_accounts_with_virtual_network_filter_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_5_4_2" {
  title         = "5.4.2 Ensure That Private Endpoints Are Used Where Possible"
  description   = "Private endpoints limit network traffic to approved sources."
  documentation = file("./cis_v300/docs/cis_v300_5_4_2.md")

  tags = {
    folder = "CIS v3.0.0/5 Database Services/5.4 Azure Cosmos DB"
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
    text     = "5.4.2 Ensure That Private Endpoints Are Used Where Possible"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_cosmosdb_accounts_without_private_link

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_5_4_3" {
  title         = "5.4.3 Use Entra ID Client Authentication and Azure RBAC where possible"
	description   = "Cosmos DB can use tokens or AAD for client authentication which in turn will use Azure RBAC for authorization. Using AAD is significantly more secure because AAD handles the credentials and allows for MFA and centralized management, and the Azure RBAC better integrated with the rest of Azure."
  documentation = file("./cis_v300/docs/cis_v300_5_4_3.md")

  tags = {
    folder = "CIS v3.0.0/5 Database Services/5.4 Azure Cosmos DB"
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
    text     = "5.4.3 Use Entra ID Client Authentication and Azure RBAC where possible"
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
