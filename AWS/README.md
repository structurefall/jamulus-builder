# Jamulus Builder - AWS Version

## What does this do?
This (Terraform)[https://www.terraform.io] code will build a Linux-based
(Jamulus)[http://llcon.sourceforge.net/] server environment in the Amazon
public cloud, (AWS)[https://aws.amazon.com].

This should allow you and your friends to collaborate on music remotely in a
reasonably private, relatively low-latency environment.

## Do I need to know Linux to use this?
Not really, but some familiarity with Linux and cloud concepts would help.

## Does it cost money?
**YES.** AWS resources are not free, and Amazon will charge you for this. We
estimate costs to be less than $40 per month. A GCP version is coming soon,
which should be cheaper.

## Prerequisites
### Server
In order to use this code, you'll need to (install Terraform)[https://learn.hashicorp.com/terraform/getting-started/install.html], as well as the (AWS command line interface)[https://aws.amazon.com/cli/].

### Client
Each client machine should install Jamulus, and try it out on public servers
first. **Make sure your audio interface is outputting at 48k** or your sound
may get severely garbled

## Usage

You'll need to configure a profile using `aws configure`, and you'll have to
read their docs on how to do that. The `main.tf` files in this directory as
well as the "Initializer" directory use a profile called `personal` and the AWS
`us-west-1` region. Feel free to change those to suit your needs, but make sure
that they match.

Once you have those configured, change to the Initializer directory and type:
```
terraform init && terraform apply
```
That will build the necessary resources for Terraform to manage itself in your
AWS account correctly- an S3 bucket with state information and a DynamoDB table
to manage locking.

Once those operations complete, I recommend that you check the AWS console to
make sure the resources built as expected.

After that, from _this_ directory,
type:
```
terraform init && terraform apply
```
That will probably take a while. It will build:

* A new VPC for your Jamulus resources
* A subnet, internet gateway, and routes for that VPC
* A launch template including a startup script to download and build the Jamulus server on autoscaling hosts
* An autoscale group limited to a single host to build the launch template
* A load balancer and associated listeners to present your server to the internet
* Security groups to manage host access and health checks

The only two components in there with a specific cost are the hosts resulting
from the autoscale group and the load balancer. Those should cost about $26 per
month, but egress costs are additional so I would count on spending more. If
you're nervous about this, consult a professional to look at your infrastructure.

The apply command will output a DNS name for your load balancer. You can use
that directly in the Jamulus client, or use your own DNS domain to point it at
something more easily human-readable.

Note that it is likely to take ~5 minutes from the completion of the terraform
job for a host to actually become available.

## SSH access
If you want SSH access to your hosts, you'll need to do two things.

First, create or import an SSH "key pair," either from the AWS EC2 console or
the command line interface. I do not recommend trying to do that with terraform.
Make sure you remember the key pair's name.

Second, you'll need your local IP address. I recommend (ifconfig.co)[https://ifconfig.co/]
for checking this.

Once you have those, create a file in this directory called `terraform.tfvars`.
The contents of the file should look like this:
```
keypair = "YOURKEYNAME"
sships = ["YOUR.IP.ADDRESS"]
```
Run `terraform apply` from this directory again (or for the first time,) and all
future autoscale hosts will allow SSH access from your IP. If you already have a
host up and running, simply terminate it and a new one will build in a minute.

## Security concerns
**Do not store secure data on these machines.** Hosts built with this module are
locked down by security group, but have a public, internet-facing IP address.
Doing this the best-practices-formal way to avoid that would have meant adding a
NAT instance, which more than doubles the monthly cost to run this setup, so we
decided against it.

Also, be very careful with your AWS key and private key, and rotate it regularly.
They're significant security targets. If you have reason to believe your AWS
credentials have been compromised, disable them in the console immediately! 
