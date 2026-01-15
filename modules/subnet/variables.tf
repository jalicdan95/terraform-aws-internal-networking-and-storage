variable "vpc_id" { 
    type = string 
}

variable "cidrs"  { 
    type = list(string) 
}

variable "azs"    { 
    type = list(string) 
}

variable "tags"   { 
    type = map(string) 
}
