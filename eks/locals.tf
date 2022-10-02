locals {
  name            = "ex-${replace(basename(path.cwd), "_", "-")}"
  cluster_version = "1.22"
  region          = "us-east-1"

  tags = {
    Example = local.name
  }
}
