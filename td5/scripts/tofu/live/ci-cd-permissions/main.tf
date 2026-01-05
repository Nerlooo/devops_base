provider "aws" {
    region = "us-east-2" # Replace with your desired region
}
module "oidc_provider" {

    source = "github.com/Nerlooo/devops_base//td5/scripts/tofu/modules/github-aws-oidc"

    provider_url = "https://token.actions.githubusercontent.com"
}

module "iam_roles" {

    source = "github.com/Nerlooo/devops_base//td5/scripts/tofu/modules/gh-actions-iam-roles"

    name = "lambda-sample"
    oidc_provider_arn = module.oidc_provider.oidc_provider_arn

    enable_iam_role_for_testing = true

    enable_iam_role_for_plan = true # Add for plan role
    enable_iam_role_for_apply = true # Add for apply role
    
    # TODO: Replace with your own GitHub repo name!
    github_repo = "Nerlooo/devops_base" # ex: "bta-devops/cloud-native-devops-kubernetes-2e"

    lambda_base_name = "lambda-sample"
    tofu_state_bucket = "shoumanbucket" # Replace with your bucket name
    tofu_state_dynamodb_table = "shoumanbucket" # Replace with your table name
}
