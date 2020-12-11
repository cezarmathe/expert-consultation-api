# expert-consultation-api - variables

variable "db_instance_type" {
  type        = string
  description = "Database instance type."
  default     = "db.t2.micro"
}

variable "client_image" {
  type        = string
  description = "Client application Docker image."
  default     = "legal-client"
}

variable "api_image" {
  type        = string
  description = "API Docker image."
  default     = "expert-consultation-api"
}

variable "db_username" {
  type        = string
  description = "Database username."
}

variable "db_password" {
  type        = string
  description = "Database password."
}
