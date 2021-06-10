# PowerShell SonarCloud Module

The [sonarcloud.io](https://sonarcloud.io/) website provides an [API](https://sonarcloud.io/web_api/) for working with their system. This PowerShell module works with that [API](https://sonarcloud.io/web_api/).

**Note: this module is a community project and is not in any way supported by SonarCloud.**

**Pre-Requisites**

PowerShell version 7.1 or later.

An API key from SonarCloud is required. You can generate one after signing into your SonarCloud account [here](https://sonarcloud.io/account/security/).

**Installation**

You can grab the latest version of the module from the PowerShell Gallery by running the following command:

```
Install-Module -Name PSSonarCloud
```

To see a list of available functions:

```
Get-Command -Module PSSonarCloud
```

**Quick Start**

Use of non-inventory functions:

Supply your API key to create a connection variable

```
Connect-SonarCloud -APIKey 'xxx-xxx-xxx'
```