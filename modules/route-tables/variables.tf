variable "vpc_id"     { 
    type = string 
}

variable "subnet_map" {
  type = map(string)
}

variable "tags"       { 
    type = map(string) 
}
