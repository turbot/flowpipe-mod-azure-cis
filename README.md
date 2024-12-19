# Azure CIS Mod for Flowpipe

Pipelines to detect and remediate Azure resources non-compliant with CIS benchmarks.

## Documentation

- **[Pipelines →](https://hub.flowpipe.io/mods/turbot/azure_cis/pipelines)**

## Getting Started

### Requirements

Docker daemon must be installed and running. Please see [Install Docker Engine](https://docs.docker.com/engine/install/) for more information.

### Installation

Download and install Flowpipe (https://flowpipe.io/downloads) and Steampipe (https://steampipe.io/downloads). Or use Brew:

```sh
brew install turbot/tap/flowpipe
brew install turbot/tap/steampipe
```

Install the Azure plugin with [Steampipe](https://steampipe.io):

```sh
steampipe plugin install azure
```

Steampipe will automatically use your default Azure credentials. Optionally, you can [setup multiple subscriptions](https://hub.steampipe.io/plugins/turbot/azure#multi-subscription-connections) or [customize Azure credentials](https://hub.steampipe.io/plugins/turbot/azure#configuring-azure-credentials).

Create a `connection_import` resource to import your Steampipe Azure connections:

```sh
vi ~/.flowpipe/config/azure.fpc
```

```hcl
connection_import "azure" {
  source      = "~/.steampipe/config/azure.spc"
  connections = ["*"]
}
```

For more information on importing connections, please see [Connection Import](https://flowpipe.io/docs/reference/config-files/connection_import).

For more information on connections in Flowpipe, please see [Managing Connections](https://flowpipe.io/docs/run/connections).

Install the mod:

```sh
mkdir azure-cis
cd azure-cis
flowpipe mod install github.com/turbot/flowpipe-mod-azure-cis
```

Install the dependencies:

```sh
flowpipe mod install
```

### Running CIS Pipelines

To run your first CIS pipeline, you'll need to ensure your Steampipe server is up and running:

```sh
steampipe service start
```

To find your desired CIS pipeline, you can filter the `pipeline list` output:

```sh
flowpipe pipeline list | grep "cis"
```

Then run your chosen pipeline:

```sh
flowpipe pipeline run azure_cis.pipeline.cis_v300
```

By default the above approach would find the relevant resources and then send a message to your configured [notifier](https://flowpipe.io/docs/reference/config-files/notifier).

### Configure Variables

Several pipelines have [input variables](https://flowpipe.io/docs/build/mod-variables#input-variables) that can be configured to better match your environment and requirements.

The easiest approach is to setup your `flowpipe.fpvars` file, starting with the example file:

```sh
cp flowpipe.fpvars.example flowpipe.fpvars
vi flowpipe.fpvars
```

Alternatively, you can pass variables on the command line:

```sh
flowpipe pipeline run azure_cis.pipeline.cis_v300 --var notifier=notifier.default
```

Or through environment variables:

```sh
export FP_VAR_notifier="notifier.default"
flowpipe pipeline run azure_cis.pipeline.cis_v300
```

For more information, please see [Passing Input Variables](https://flowpipe.io/docs/build/mod-variables#passing-input-variables)

## Open Source & Contributing

This repository is published under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0). Please see our [code of conduct](https://github.com/turbot/.github/blob/main/CODE_OF_CONDUCT.md). We look forward to collaborating with you!

[Flowpipe](https://flowpipe.io) and [Steampipe](https://steampipe.io) are products produced from this open source software, exclusively by [Turbot HQ, Inc](https://turbot.com). They are distributed under our commercial terms. Others are allowed to make their own distribution of the software, but cannot use any of the Turbot trademarks, cloud services, etc. You can learn more in our [Open Source FAQ](https://turbot.com/open-source).

## Get Involved

**[Join #flowpipe on Slack →](https://turbot.com/community/join)**

Want to help but don't know where to start? Pick up one of the `help wanted` issues:

- [Flowpipe](https://github.com/turbot/flowpipe/labels/help%20wanted)
- [Azure CIS Mod](https://github.com/turbot/flowpipe-mod-azure-cis/labels/help%20wanted)
