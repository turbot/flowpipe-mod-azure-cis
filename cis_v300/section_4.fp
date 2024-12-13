locals {
  cis_v300_4_control_mapping = {
    cis_v300_4_1   = pipeline.cis_v300_4_1
    cis_v300_4_2   = pipeline.cis_v300_4_2
    cis_v300_4_3   = pipeline.cis_v300_4_3
    cis_v300_4_4   = pipeline.cis_v300_4_4
    cis_v300_4_5   = pipeline.cis_v300_4_5
    cis_v300_4_6   = pipeline.cis_v300_4_6
    cis_v300_4_7   = pipeline.cis_v300_4_7
    cis_v300_4_8   = pipeline.cis_v300_4_8
		cis_v300_4_9   = pipeline.cis_v300_4_9
		cis_v300_4_10  = pipeline.cis_v300_4_10
    cis_v300_4_11  = pipeline.cis_v300_4_11
    cis_v300_4_12  = pipeline.cis_v300_4_12
		cis_v300_4_13  = pipeline.cis_v300_4_13
		cis_v300_4_14  = pipeline.cis_v300_4_14
		cis_v300_4_15  = pipeline.cis_v300_4_15
		cis_v300_4_16  = pipeline.cis_v300_4_16
		cis_v300_4_17  = pipeline.cis_v300_4_17
  }
}

pipeline "cis_v300_4" {
  title         = "4 Storage Accounts"
  description   = "This section contains recommendations for configuring Azure Storage Accounts."
  documentation = file("./cis_v300/docs/cis_v300_4.md")

  tags = {
    folder = "CIS v3.0.0/4 Storage Accounts"
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
    text     = "4 Storage Accounts"
  }

  step "pipeline" "cis_v300_4" {
    depends_on = [step.message.header]

    loop {
      until = loop.index >= (length(keys(local.cis_v300_4_control_mapping)) - 1)
    }

    pipeline = local.cis_v300_4_control_mapping[keys(local.cis_v300_4_control_mapping)[loop.index]]

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_4_1" {
  title         = "4.1 Ensure that 'Secure transfer required' is set to 'Enabled'"
  description   = "Enable data encryption in transit."
  documentation = file("./cis_v300/docs/cis_v300_4_1.md")

  tags = {
    folder = "CIS v3.0.0/4 Storage Accounts"
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
    text     = "4.1 Ensure that 'Secure transfer required' is set to 'Enabled'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_storage_accounts_with_secure_transfer_required_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_4_2" {
  title         = "4.2 Ensure that 'Enable Infrastructure Encryption' for Each Storage Account in Azure Storage is Set to 'enabled'"
  description   = "Enabling encryption at the hardware level on top of the default software encryption for Storage Accounts accessing Azure storage solutions."
  documentation = file("./cis_v300/docs/cis_v300_4_2.md")

  tags = {
    folder = "CIS v3.0.0/4 Storage Accounts"
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
    text     = "4.2 Ensure that 'Enable Infrastructure Encryption' for Each Storage Account in Azure Storage is Set to 'enabled'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_storage_accounts_with_infrastructure_encryption_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_4_3" {
  title         = "4.3 Ensure that 'Enable key rotation reminders' is enabled for each Storage Account"
  description   = "Access Keys authenticate application access requests to data contained in Storage Accounts. A periodic rotation of these keys is recommended to ensure that potentially compromised keys cannot result in a long-term exploitable credential. The 'Rotation Reminder' is an automatic reminder feature for a manual procedure."
  documentation = file("./cis_v300/docs/cis_v300_4_3.md")

  tags = {
    folder = "CIS v3.0.0/4 Storage Accounts"
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
    text     = "4.3 Ensure that 'Enable key rotation reminders' is enabled for each Storage Account"
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

pipeline "cis_v300_4_4" {
  title         = "4.4 Ensure that Storage Account Access Keys are Periodically Regenerated"
  description   = "For increased security, regenerate storage account access keys periodically."
  documentation = file("./cis_v300/docs/cis_v300_4_4.md")

  tags = {
    folder = "CIS v3.0.0/4 Storage Accounts"
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
    text     = "4.4 Ensure that Storage Account Access Keys are Periodically Regenerated"
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

pipeline "cis_v300_4_5" {
  title         = "4.5 Ensure that Shared Access Signature Tokens Expire Within an Hour"
  description   = "Expire shared access signature tokens within an hour."
  documentation = file("./cis_v300/docs/cis_v300_4_5.md")

  tags = {
    folder = "CIS v3.0.0/4 Storage Accounts"
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
    text     = "4.5 Ensure that Shared Access Signature Tokens Expire Within an Hour"
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

pipeline "cis_v300_4_6" {
  title         = "4.6 Ensure that 'Public Network Access' is `Disabled' for storage accounts"
  description   = "Disallowing public network access for a storage account overrides the public access settings for individual containers in that storage account for Azure Resource Manager Deployment Model storage accounts. Azure Storage accounts that use the classic deployment model will be retired on August 31, 2024."
  documentation = file("./cis_v300/docs/cis_v300_4_6.md")

  tags = {
    folder = "CIS v3.0.0/4 Storage Accounts"
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
    text     = "4.6 Ensure that 'Public Network Access' is `Disabled' for storage accounts"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_storage_accounts_with_public_access_enabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_4_7" {
  title         = "4.7 Ensure Default Network Access Rule for Storage Accounts is Set to Deny"
  description   = "Restricting default network access helps to provide a new layer of security, since storage accounts accept connections from clients on any network. To limit access to selected networks, the default action must be changed."
  documentation = file("./cis_v300/docs/cis_v300_4_7.md")

  tags = {
    folder = "CIS v3.0.0/4 Storage Accounts"
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
    text     = "4.7 Ensure Default Network Access Rule for Storage Accounts is Set to Deny"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_storage_accounts_with_default_network_access_rule_allowed

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_4_8" {
  title         = "4.8 Ensure 'Allow Azure services on the trusted services list to access this storage account' is Enabled for Storage Account Access"
  description   = "Some Azure services that interact with storage accounts operate from networks that can't be granted access through network rules. To help this type of service work as intended, allow the set of trusted Azure services to bypass the network rules. These services will then use strong authentication to access the storage account."
  documentation = file("./cis_v300/docs/cis_v300_4_8.md")

  tags = {
    folder = "CIS v3.0.0/4 Storage Accounts"
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
    text     = "4.8 Ensure 'Allow Azure services on the trusted services list to access this storage account' is Enabled for Storage Account Access"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_storage_accounts_with_trusted_microsoft_services_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_4_9" {
  title         = "4.9 Ensure Private Endpoints are used to access Storage Accounts"
  description   = "Use private endpoints for your Azure Storage accounts to allow clients and services to securely access data located over a network via an encrypted Private Link. To do this, the private endpoint uses an IP address from the VNet for each service. Network traffic between disparate services securely traverses encrypted over the VNet."
  documentation = file("./cis_v300/docs/cis_v300_4_9.md")

  tags = {
    folder = "CIS v3.0.0/4 Storage Accounts"
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
    text     = "4.9 Ensure Private Endpoints are used to access Storage Accounts"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_storage_accounts_without_private_link

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_4_10" {
  title         = "4.10 Ensure Soft Delete is Enabled for Azure Containers and Blob Storage"
  description   = "The Azure Storage blobs contain data like ePHI or Financial, which can be secret or personal. Data that is erroneously modified or deleted by an application or other storage account user will cause data loss or unavailability."
  documentation = file("./cis_v300/docs/cis_v300_4_10.md")

  tags = {
    folder = "CIS v3.0.0/4 Storage Accounts"
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
    text     = "4.10 Ensure Soft Delete is Enabled for Azure Containers and Blob Storage"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_storage_accounts_with_blob_soft_delete_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_4_11" {
  title         = "4.11 Ensure Storage for Critical Data are Encrypted with Customer Managed Keys"
  description   = "Enable sensitive data encryption at rest using Customer Managed Keys rather than Microsoft Managed keys."
  documentation = file("./cis_v300/docs/cis_v300_4_11.md")

  tags = {
    folder = "CIS v3.0.0/4 Storage Accounts"
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
    text     = "4.11 Ensure Storage for Critical Data are Encrypted with Customer Managed Keys"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_storage_accounts_with_encryption_at_rest_using_cmk_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_4_12" {
  title         = "4.12 Ensure Storage Logging is Enabled for Queue Service for 'Read', 'Write', and 'Delete' requests"
  description   = "The Storage Queue service stores messages that may be read by any client who has access to the storage account. A queue can contain an unlimited number of messages, each of which can be up to 64KB in size using version 2011-08-18 or newer. Storage Logging happens server-side and allows details for both successful and failed requests to be recorded in the storage account."
  documentation = file("./cis_v300/docs/cis_v300_4_12.md")

  tags = {
    folder = "CIS v3.0.0/4 Storage Accounts"
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
    text     = "4.12 Ensure Storage Logging is Enabled for Queue Service for 'Read', 'Write', and 'Delete' requests"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_storage_accounts_with_queue_service_logging_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_4_13" {
  title         = "4.13 Ensure Storage logging is Enabled for Blob Service for 'Read', 'Write', and 'Delete' requests"
  description   = "The Storage Blob service provides scalable, cost-efficient object storage in the cloud. Storage Logging happens server-side and allows details for both successful and failed requests to be recorded in the storage account. These logs allow users to see the details of read, write, and delete operations against the blobs. Storage Logging log entries contain the following information about individual requests: timing information such as start time, end-to-end latency, and server latency; authentication details; concurrency information; and the sizes of the request and response messages."
  documentation = file("./cis_v300/docs/cis_v300_4_13.md")

  tags = {
    folder = "CIS v3.0.0/4 Storage Accounts"
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
    text     = "4.13 Ensure Storage logging is Enabled for Blob Service for 'Read', 'Write', and 'Delete' requests"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_storage_accounts_with_blob_service_logging_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_4_14" {
  title         = "4.14 Ensure Storage Logging is Enabled for Table Service for 'Read', 'Write', and 'Delete' Requests"
  description   = "Azure Table storage is a service that stores structured NoSQL data in the cloud, providing a key/attribute store with a schema-less design. Storage Logging happens server-side and allows details for both successful and failed requests to be recorded in the storage account. These logs allow users to see the details of read, write, and delete operations against the tables. Storage Logging log entries contain the following information about individual requests: timing information such as start time, end-to-end latency, and server latency; authentication details; concurrency information; and the sizes of the request and response messages."
  documentation = file("./cis_v300/docs/cis_v300_4_14.md")

  tags = {
    folder = "CIS v3.0.0/4 Storage Accounts"
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
    text     = "4.14 Ensure Storage Logging is Enabled for Table Service for 'Read', 'Write', and 'Delete' Requests"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_storage_accounts_with_table_service_logging_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_4_15" {
  title         = "4.15 Ensure the 'Minimum TLS version' for storage accounts is set to 'Version 1.2'"
  description   = "In some cases, Azure Storage sets the minimum TLS version to be version 1.0 by default. TLS 1.0 is a legacy version and has known vulnerabilities. This minimum TLS version can be configured to be later protocols such as TLS 1.2."
  documentation = file("./cis_v300/docs/cis_v300_4_15.md")

  tags = {
    folder = "CIS v3.0.0/4 Storage Accounts"
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
    text     = "4.15 Ensure the 'Minimum TLS version' for storage accounts is set to 'Version 1.2'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_storage_accounts_with_no_min_tls_1_2

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_4_16" {
  title         = "4.16 Ensure 'Cross Tenant Replication' is not enabled"
  description   = "Cross Tenant Replication in Azure allows data to be replicated across multiple Azure tenants. While this feature can be beneficial for data sharing and availability, it also poses a significant security risk if not properly managed. Unauthorized data access, data leakage, and compliance violations are potential risks. Disabling Cross Tenant Replication ensures that data is not inadvertently replicated across different tenant boundaries without explicit authorization."
  documentation = file("./cis_v300/docs/cis_v300_4_16.md")

  tags = {
    folder = "CIS v3.0.0/4 Storage Accounts"
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
    text     = "4.16 Ensure 'Cross Tenant Replication' is not enabled"
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

pipeline "cis_v300_4_17" {
  title         = "4.17 Ensure that `Allow Blob Anonymous Access` is set to `Disabled`"
  description   = "The Azure Storage setting 'Allow Blob Anonymous Access' (aka 'allowBlobPublicAccess') controls whether anonymous access is allowed for blob data in a storage account. When this property is set to True, it enables public read access to blob data, which can be convenient for sharing data but may carry security risks. When set to False, it disallows public access to blob data, providing a more secure storage environment."
  documentation = file("./cis_v300/docs/cis_v300_4_17.md")

  tags = {
    folder = "CIS v3.0.0/4 Storage Accounts"
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
    text     = "4.17 Ensure that `Allow Blob Anonymous Access` is set to `Disabled`"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_storage_accounts_with_blob_public_access_enabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}