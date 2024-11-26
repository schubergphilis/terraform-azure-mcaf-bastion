terraform {
  required_version = ">= 1.8"
}

module "bastion" {
  source = "../.."

}
