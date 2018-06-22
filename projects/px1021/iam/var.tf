# Following a pattern from here:
# https://serialseb.com/blog/2016/05/11/terraform-working-around-no-count-on-module/

variable "role-delimiter" {
  default     = " "
  description = "The character to delimit the input roles by (workaround for modules not supporting 'count')"
}

variable "region" {
  default     = ""
  description = "Which AWS region to operate in? Defaults to blank, so that prompts/errors will occur"
}
