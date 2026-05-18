# infra-as-code-with-terraform

You have a production cluster, you need 3 more, and you're going to script it rather than click through the console three times.

Milestone 1 is about writing the Terraform config once, correctly. The payoff is running it 3 times with different tfvars files (dev.tfvars, test.tfvars, staging.tfvars) to get 3 identical environments.

Milestone 2 is about team safety. Once more than one person is running terraform apply, local state is a liability. S3 + DynamoDB locking makes sure no two pipeline runs trample each other.

Milestone 3 is about removing humans from the loop entirely. The platform team pushes to the Terraform repo, the pipeline provisions the cluster. The manual approval gate before apply is the last checkpoint before infra changes hit a live environment.

![alt text](eks_multi_env_roadmap.svg)