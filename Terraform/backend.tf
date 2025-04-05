terraform {
  backend "remote" {
    organization = "devopsensei"  # Your Terraform Cloud org name

    workspaces {
      name = "devopsensei"  # The workspace name you just created
    }
  }
}
