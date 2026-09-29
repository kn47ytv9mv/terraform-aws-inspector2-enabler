variable "account_ids" {
  default     = null
  description = "Accounts to enable Amazon Inspector in. Left null, this account. Any other account has to already be a member of your Inspector organization, or the apply fails."
}

variable "resource_types" {
  default     = ["EC2", "ECR", "LAMBDA"]
  description = "What Inspector scans (e.g. 'EC2', 'ECR', 'LAMBDA', 'LAMBDA_CODE', 'CODE_REPOSITORY'). Each type is billed separately — see the README. LAMBDA covers dependency vulnerabilities; LAMBDA_CODE adds static analysis of the function code itself and is billed on top."

  validation {
    condition = length(var.resource_types) > 0 && alltrue([
      for t in var.resource_types :
      contains(["EC2", "ECR", "LAMBDA", "LAMBDA_CODE", "CODE_REPOSITORY"], t)
    ])
    error_message = "resource_types must be non-empty and drawn from 'EC2', 'ECR', 'LAMBDA', 'LAMBDA_CODE' and 'CODE_REPOSITORY'."
  }
}
