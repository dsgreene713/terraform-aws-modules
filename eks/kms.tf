resource "aws_kms_key" "eks_cluster" {
  count = local.create_encryption_kms_key ? 1 : 0

  description             = "customer managed key to encrypt ${local.cluster_name} secrets"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_kms_alias" "eks_cluster" {
  count = local.create_encryption_kms_key ? 1 : 0

  name          = "${var.kms_alias_prefix_path}/kms/eks/${local.cluster_name}/secrets"
  target_key_id = aws_kms_key.eks_cluster[0].key_id
}

resource "aws_kms_key" "eks_cloudwatch" {
  description             = "customer managed key to encrypt ${local.cluster_name} cloudwatch logs"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.cloudwatch.json
}

resource "aws_kms_alias" "eks_cloudwatch" {
  name          = "${var.kms_alias_prefix_path}/kms/eks/${local.cluster_name}/cloudwatch"
  target_key_id = aws_kms_key.eks_cloudwatch.key_id
}

resource "aws_kms_key" "eks_ebs" {
  description             = "customer managed key to encrypt ${local.cluster_name} self managed node group volumes"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.ebs.json
}

resource "aws_kms_alias" "eks_ebs" {
  name          = "${var.kms_alias_prefix_path}/kms/eks/${local.cluster_name}/ebs"
  target_key_id = aws_kms_key.eks_ebs.key_id
}
