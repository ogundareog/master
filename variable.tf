variable "encrypted" {
      type = bool
      default = true
    }          


#variable "kms_key_id" {
#      default = "arn:aws:kms:us-east-1:468390354164:key/mrk-af1db2fe76a446ef8c17d0b7457363f5"
#    }    

variable  "access_key" {
     default = "AKIAYLTQHBG4RSUS4DNZ"
  }
   
variable "secret_key" {
     default = "/5Tt9toBpDO1pqwBJ5OtxGvRs4I2pJPJDR4GF6ke"
   }

variable "acl" {
  default = "private"
}
variable "key_name" {
  default = "esgapps"
}
variable "create_cluster" {
  type    = bool
  default = true
}
