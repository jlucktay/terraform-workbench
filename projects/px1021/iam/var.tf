variable "region" {
  description = "Which AWS region to operate in?  No default is set, so that prompts will occur"
}

variable "role-delimiter" {
  default     = " "
  description = "The character to delimit the input roles by (workaround for modules not supporting 'count')"
}
