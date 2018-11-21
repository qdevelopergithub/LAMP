# Azure Managed Application

[Azure Managed
Applications](https://docs.microsoft.com/en-us/azure/managed-applications/overview) enable you to offer your Lamp based
solutions to customers via the [Azure Marketplace](https://azuremarketplace.microsoft.com/en-us/marketplace/) or a Service Catalog. You define the
infrastructure for the solution, using the ARM templates in this
repository as a starting point, along with the terms for ongoing
management of the solution. The billing for your solution is handled
through Azure billing.

## Why the Azure Marketplace and Azure Managed Applications for Lamp Hosting Providers
The Azure Marketplace allows you the capability of offering an Azure-certified Lamp solution via a modern marketplace. When a customer runs Lamp from the Azure Marketplace they have the confidence that the Lamp solution certified and optimized to run on Azure, and that they can get support should they need it. 

Until recently it was difficult for many Lamp hosting providers to offer Lamp via the Azure Marketplace, in particular because after a marketplace solution was deployed, customers would still be responsible for maintaining, updating, or servicing their environment. As customers are not always experts on cloud infrastructure this made offering a Marketplace offering with a Lamp-hoster backed SLA difficult.  Moreover, a customer had full-access to the resources (i.e. VMs, databases, etc.) in the solution once deployed, meaning they could easily make a change to the underlying infrastructure (such as accidentally deleting a critical VM) that might have rendered the solution unusable.  

With the advent of Azure Managed Application for the Azure Marketplace, the Lamp Hosting provider can now specify exactly which underlying infrastructure resources for a Lamp solution a customer does (and does not) have access to. This means that a Lamp hoster can now prevent a customer from make a change which could take down your Lamp solution and render your SLA void. Moreover, although customers continue to deploy your Lamp solution offering in their subscriptions just like all Azure Marketplace offerings, the customer does not have to maintain, update, or service them and troubleshooting and diagnosing of issues can be done by the Lamp hoster on-behalf of the customer.

## Why Lamp Managed Applications for IT Teams?
For IT teams, managed applications enable you to offer pre-approved configuration of Lamp
to users in the organization. For example, if to be compliant with organizational standards you require users deploy Lamp with certain version number, database SKUs or networking/security configurations, you can enforce compliance. 

Read more about [Managed
Applications](https://docs.microsoft.com/en-us/azure/managed-applications/overview),
or keep reading here to see how to quickly get started providing your
own Lamp based services as Managed Applications.

## Next Steps

  1. [Publish a Managed Application Definition](PublishLampManagedApplication.md)
  2. [Deploy a Lamp Based Managed Application](DeployLampManagedApp.md)
  3. [Learn about submitting your application to the Azure Marketplace](https://docs.microsoft.com/en-us/azure/marketplace/marketplace-publishers-guide)
  4. [Submit your application to the Azure Marketplace](https://azuremarketplace.microsoft.com/en-us/sell/nominate)
  
