mock_provider "aws" {
  mock_data "aws_caller_identity" {
    defaults = { account_id = "123456789012" }
  }
}

run "an_empty_resource_type_list_is_rejected" {
  command = plan

  variables {
    resource_types = []
  }

  expect_failures = [var.resource_types]
}

run "an_unknown_resource_type_is_rejected" {
  command = plan

  variables {
    resource_types = ["S3"]
  }

  expect_failures = [var.resource_types]
}

run "defaults_scan_this_account" {
  command = apply

  assert {
    condition     = aws_inspector2_enabler.resource.account_ids == toset(["123456789012"])
    error_message = "With no account_ids given, Inspector should be enabled in the calling account."
  }

  assert {
    condition     = aws_inspector2_enabler.resource.resource_types == toset(["EC2", "ECR", "LAMBDA"])
    error_message = "The default scan set should cover EC2, ECR and Lambda dependencies."
  }
}

run "explicit_accounts_override_the_caller" {
  command = plan

  variables {
    account_ids = ["111111111111", "222222222222"]
  }

  assert {
    condition     = length(aws_inspector2_enabler.resource.account_ids) == 2
    error_message = "Explicit account_ids should replace the calling account rather than add to it."
  }
}

run "lambda_code_scanning_can_be_added" {
  command = plan

  variables {
    resource_types = ["EC2", "ECR", "LAMBDA", "LAMBDA_CODE"]
  }

  assert {
    condition     = contains(aws_inspector2_enabler.resource.resource_types, "LAMBDA_CODE")
    error_message = "LAMBDA_CODE should be passed through when asked for."
  }
}
