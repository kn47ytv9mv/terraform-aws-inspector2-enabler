data "aws_caller_identity" "current" {}

resource "aws_inspector2_enabler" "resource" {
  account_ids    = coalesce(var.account_ids, [data.aws_caller_identity.current.account_id])
  resource_types = var.resource_types
}

output "account_ids" {
  description = "The accounts Inspector was enabled in."
  value       = aws_inspector2_enabler.resource.account_ids
}

output "resource_types" {
  description = "The resource types Inspector is scanning."
  value       = aws_inspector2_enabler.resource.resource_types
}
