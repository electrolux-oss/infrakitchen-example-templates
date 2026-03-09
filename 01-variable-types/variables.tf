variable "name" {
  description = "Simple string variable"
  type        = string
  default     = "infrakitchen-demo"
}

variable "instance_count" {
  description = "Simple number variable"
  type        = number
  default     = 2
}

variable "enabled" {
  description = "Simple boolean variable"
  type        = bool
  default     = true
}

variable "subnet_ids" {
  description = "List of string values"
  type        = list(string)
  default     = ["subnet-a", "subnet-b"]
}

variable "tags" {
  description = "Map of strings"
  type        = map(string)
  default = {
    environment = "dev"
    owner       = "platform"
  }
}

variable "settings" {
  description = "Object variable"
  type = object({
    region                = string
    private               = bool
    allowed_cidr_blocks   = list(string)
    max_unavailable_nodes = number
  })
  default = {
    region                = "eu-west-1"
    private               = true
    allowed_cidr_blocks   = ["10.0.0.0/16", "10.1.0.0/16"]
    max_unavailable_nodes = 1
  }
}

variable "services" {
  description = "List of objects variable"
  type = list(object({
    name    = string
    port    = number
    enabled = bool
  }))
  default = [
    {
      name    = "api"
      port    = 8080
      enabled = true
    },
    {
      name    = "worker"
      port    = 9090
      enabled = false
    }
  ]
}

variable "availability_zones" {
  description = "Set variable"
  type        = set(string)
  default     = ["eu-west-1a", "eu-west-1b"]
}

variable "dynamic_payload" {
  description = "Any type variable for JSON payload testing"
  type        = any
  default = {
    feature_flags = {
      canary = true
    }
    retries = 3
    notes   = ["created-by", "infrakitchen"]
  }
}
