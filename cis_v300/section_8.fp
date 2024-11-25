locals {
  cis_v300_8_control_mapping = {
    cis_v300_8_1   = pipeline.cis_v300_8_1
    cis_v300_8_2   = pipeline.cis_v300_8_2
    cis_v300_8_3   = pipeline.cis_v300_8_3
    cis_v300_8_4   = pipeline.cis_v300_8_4
    cis_v300_8_5   = pipeline.cis_v300_8_5
    cis_v300_8_6   = pipeline.cis_v300_8_6
    cis_v300_8_7   = pipeline.cis_v300_8_7
    cis_v300_8_8   = pipeline.cis_v300_8_8
		cis_v300_8_9   = pipeline.cis_v300_8_9
		cis_v300_8_10  = pipeline.cis_v300_8_10
    cis_v300_8_11  = pipeline.cis_v300_8_11
  }
}

pipeline "cis_v300_8" {
  title         = "8 Virtual Machines"
  description   = "This section contains recommendations for configuring Azure Virtual Machines."
  documentation = file("./cis_v300/docs/cis_v300_8.md")

  tags = {
    folder = "CIS v3.0.0/8 Virtual Machines"
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
    text     = "8 Virtual Machines"
  }

  step "pipeline" "cis_v300_8" {
    depends_on = [step.message.header]

    loop {
      until = loop.index >= (length(keys(local.cis_v300_8_control_mapping)) - 1)
    }

    pipeline = local.cis_v300_8_control_mapping[keys(local.cis_v300_8_control_mapping)[loop.index]]

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_8_1" {
  title         = "8.1 Ensure an Azure Bastion Host Exists"
  description   = "The Azure Bastion service allows secure remote access to Azure Virtual Machines over the Internet without exposing remote access protocol ports and services directly to the Internet. The Azure Bastion service provides this access using TLS over 443/TCP, and subscribes to hardened configurations within an organization's Azure Active Directory service."
  documentation = file("./cis_v300/docs/cis_v300_8_1.md")

  tags = {
    folder = "CIS v3.0.0/8 Virtual Machines"
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
    text     = "8.1  Ensure an Azure Bastion Host Exists"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_subscriptions_with_no_network_bastion_host

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_8_2" {
  title         = "8.2 Ensure Virtual Machines are utilizing Managed Disks"
  description   = "Migrate blob-based VHDs to Managed Disks on Virtual Machines to exploit the default features of this configuration."
  documentation = file("./cis_v300/docs/cis_v300_8_2.md")

  tags = {
    folder = "CIS v3.0.0/8 Virtual Machines"
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
    text     = "8.2 Ensure Virtual Machines are utilizing Managed Disks"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_compute_vms_not_utilizing_managed_disk

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_8_3" {
  title         = "8.3 Ensure that 'OS and Data' disks are encrypted with Customer Managed Key (CMK)"
  description   = "Ensure that OS disks (boot volumes) and data disks (non-boot volumes) are encrypted with CMK (Customer Managed Keys). Customer Managed keys can be either ADE or Server Side Encryption(SSE)."
  documentation = file("./cis_v300/docs/cis_v300_8_3.md")

  tags = {
    folder = "CIS v3.0.0/8 Virtual Machines"
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
    text     = "8.3 Ensure that 'OS and Data' disks are encrypted with Customer Managed Key (CMK)"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_compute_os_and_data_disks_not_encrypted_with_cmk

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_8_4" {
  title         = "8.4 Ensure that 'Unattached disks' are encrypted with 'Customer Managed Key' (CMK)"
  description   = "Ensure that unattached disks in a subscription are encrypted with a Customer Managed Key (CMK)."
  documentation = file("./cis_v300/docs/cis_v300_8_4.md")

  tags = {
    folder = "CIS v3.0.0/8 Virtual Machines"
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
    text     = "8.4 Ensure that 'Unattached disks' are encrypted with 'Customer Managed Key' (CMK)"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_compute_unattached_disk_not_encrypted_with_cmk

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_8_5" {
  title         = "8.5 Ensure that 'Disk Network Access' is NOT set to 'Enable public access from all networks'"
  description   = "Virtual Machine Disks and snapshots can be configured to allow access from different network resources."
  documentation = file("./cis_v300/docs/cis_v300_8_5.md")

  tags = {
    folder = "CIS v3.0.0/8 Virtual Machines"
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
    text     = "8.5 Ensure that 'Disk Network Access' is NOT set to 'Enable public access from all networks'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_compute_disks_with_public_access_enabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_8_6" {
  title         = "8.6 Ensure that 'Enable Data Access Authentication Mode' is 'Checked'"
  description   = "Data Access Authentication Mode provides a method of uploading or exporting Virtual Machine Disks."
  documentation = file("./cis_v300/docs/cis_v300_8_6.md")

  tags = {
    folder = "CIS v3.0.0/8 Virtual Machines"
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
    text     = "8.6 Ensure that 'Enable Data Access Authentication Mode' is 'Checked'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = azure_compliance.pipeline.detect_and_correct_compute_disks_with_data_access_auth_mode_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_8_7" {
  title         = "8.7 Ensure that Only Approved Extensions Are Installed"
  description   = "For added security, only install organization-approved extensions on VMs."
  documentation = file("./cis_v300/docs/cis_v300_8_7.md")

  tags = {
    folder = "CIS v3.0.0/8 Virtual Machines"
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
    text     = "8.7 Ensure that Only Approved Extensions Are Installed"
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

pipeline "cis_v300_8_8" {
  title         = "8.8 Ensure that Endpoint Protection for all Virtual Machines is installed"
  description   = "Install endpoint protection for all virtual machines."
  documentation = file("./cis_v300/docs/cis_v300_8_8.md")

  tags = {
    folder = "CIS v3.0.0/8 Virtual Machines"
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
    text     = "8.8 Ensure that Endpoint Protection for all Virtual Machines is installed"
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

pipeline "cis_v300_8_9" {
  title         = "8.9 [Legacy] Ensure that VHDs are Encrypted"
  description   = "VHD (Virtual Hard Disks) are stored in blob storage and are the old-style disks that were attached to Virtual Machines. The blob VHD was then leased to the VM. By default, storage accounts are not encrypted, and Microsoft Defender will then recommend that the OS disks should be encrypted. Storage accounts can be encrypted as a whole using PMK or CMK. This should be turned on for storage accounts containing VHDs."
  documentation = file("./cis_v300/docs/cis_v300_8_9.md")

  tags = {
    folder = "CIS v3.0.0/8 Virtual Machines"
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
    text     = "8.9 [Legacy] Ensure that VHDs are Encrypted"
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

pipeline "cis_v300_8_10" {
  title         = "8.10 Ensure only MFA enabled identities can access privileged Virtual Machine"
  description   = "Verify identities without MFA that can log in to a privileged virtual machine using separate login credentials. An adversary can leverage the access to move laterally and perform actions with the virtual machine's managed identity. Make sure the virtual machine only has necessary permissions, and revoke the admin-level permissions according to the least privileges principal."
  documentation = file("./cis_v300/docs/cis_v300_8_10.md")

  tags = {
    folder = "CIS v3.0.0/8 Virtual Machines"
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
    text     = "8.10 Ensure only MFA enabled identities can access privileged Virtual Machine"
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

pipeline "cis_v300_8_11" {
  title         = "8.11 Ensure Trusted Launch is enabled on Virtual Machines"
  description   = "When Secure Boot and vTPM are enabled together, they provide a strong foundation for protecting your VM from boot attacks. For example, if an attacker attempts to replace the bootloader with a malicious version, Secure Boot will prevent the VM from booting."
  documentation = file("./cis_v300/docs/cis_v300_8_11.md")

  tags = {
    folder = "CIS v3.0.0/8 Virtual Machines"
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
    text     = "8.11 Ensure Trusted Launch is enabled on Virtual Machines"
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
