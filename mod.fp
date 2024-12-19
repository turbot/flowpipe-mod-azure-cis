mod "azure_cis" {
  title         = "Azure CIS"
  description   = "Run pipelines to detect and correct Azure resources that are non-compliant with CIS benchmarks."
  color         = "#0089D6"
  documentation = file("./README.md")
  database      = var.database
  icon          = "/images/mods/turbot/azure-compliance.svg"
  categories    = ["azure", "compliance", "public cloud", "standard", "terminal"]

  opengraph {
    title       = "Azure CIS Mod for Flowpipe"
    description = "Run pipelines to detect and correct Azure resources that are non-compliant with CIS benchmarks."
    image       = "/images/mods/turbot/azure-compliance-social-graphic.png"
  }

  require {
    flowpipe {
      min_version = "1.0.0"
    }
    mod "github.com/turbot/flowpipe-mod-azure-compliance" {
      version = "^1"
    }
  }
}
