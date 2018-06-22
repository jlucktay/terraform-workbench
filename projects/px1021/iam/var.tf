variable "region" {
  default     = ""
  description = "Which AWS region to operate in? Defaults to blank, so that prompts/errors will occur"
}

variable "role-delimiter" {
  default     = " "
  description = "The character to delimit the input roles by (workaround for modules not supporting 'count')"
}
