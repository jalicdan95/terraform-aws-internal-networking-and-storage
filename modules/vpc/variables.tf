variable "cidr_block" {
    description = "The CIDR block for the VPC"
    type        = string
}

variable "tags" {
    description = "A map of tags to assign to the VPC"
    type        = map(string)
}