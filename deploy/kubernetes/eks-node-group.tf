resource "aws_iam_role" "node-group-role" {
  name = "node-group-role4"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


resource "aws_iam_role_policy_attachment" "amazon-eks-worker-node-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node-group-role.name
}

resource "aws_iam_role_policy_attachment" "amazon-eks-cni-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node-group-role.name
}

resource "aws_iam_role_policy_attachment" "amazon-ec2-container-registry-readonly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node-group-role.name
}

resource "aws_eks_node_group" "node-group" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "eks-node-group"
  node_role_arn   = aws_iam_role.node-group-role.arn
  subnet_ids = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]
  ami_type             = "AL2_x86_64"
  instance_types       = ["t2.medium"]
  capacity_type        = "ON_DEMAND"
  disk_size            = 20
  force_update_version = false
  version              = "1.22"

  scaling_config {
    desired_size = 3
    max_size     = 3
    min_size     = 1
  }
  remote_access {
    ec2_ssh_key = "qa-key1"
  }
  depends_on = [
    aws_iam_role_policy_attachment.amazon-eks-worker-node-policy,
    aws_iam_role_policy_attachment.amazon-eks-cni-policy,
    aws_iam_role_policy_attachment.amazon-ec2-container-registry-readonly
  ]
}
