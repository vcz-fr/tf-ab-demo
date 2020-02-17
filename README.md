# Terraform A/B Testing demonstration

Store and retrieve information from a DynamoDB datastore. Not exactly A/B
Testing _per se_ but a good start that should encourage experimentation.

## Introduction

This project is a demonstration for a way to kickstart an A/B Testing
experimentation relying on Serverless services on AWS. It is not meant to
replace an actual A/B Testing solution.

This demonstration deploys the following on AWS:
- One DynamoDB table;
- Two Lambda functions and one layer;
- One IAM Role to allow the Lambda functions to connect to the DynamoDB table;
- One ALB calling the Lambda functions;

This is a very, very simple A/B Testing application that does not provide basic
features because it is meant as a demonstration.

## Considerations

There was no intention of following the best practices in terms of AWS resource
management or Terraform provisioning. Comments are limited out of the meaningful
section of this code and the explanation can be found in the following blog
post.

The shortcuts taken with this example code MUST be wisely considered before
applying them to your code base. In no way they are industry standards. Always
read the [Official Terraform documentation](https://www.terraform.io/docs/) in
the version you are currently using before proceeding. Some issues may persist
in this infrastructure.

This configuration has been tested with Terraform 0.12.18 on a MacOS computer
and has preventively been locked to "~> 0.12.18".
