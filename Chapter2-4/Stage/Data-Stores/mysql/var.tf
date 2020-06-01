# this does not have a defaut on purpose so as to not store the data in plain text. Insert it as an environment variable,
# tf_var_db_password="<password>", in the terminal window.
variable "db_password" {
  description = "The password for the MySQL database"
  type = string
}
