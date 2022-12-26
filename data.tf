data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.this.id
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.this.id
}

data "aws_security_group" "eks_cluster_security_group" {
  vpc_id = aws_vpc.this.id
  filter {
    name   = "group-name"
    values = ["eks-cluster-sg-${local.cluster_name}-cluster-*"]
  }
  tags = {
    "aws:eks:cluster-name" = "${local.cluster_name}-cluster"
  }
  depends_on = [
    kubernetes_namespace.app
  ]
}

data "aws_ami" "eksUbuntu" {
  most_recent        = true
  owners             = ["amazon"]
  include_deprecated = false

  filter {
    name   = "name"
    values = ["ubuntu-eks/k8s_${var.k8s_cluster_version}/images/*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_instance" "node" {
  instance_tags = aws_launch_template.this.tag_specifications[0].tags
  filter {
    name   = "image-id"
    values = ["${data.aws_ami.eksUbuntu.image_id}"]
  }
  depends_on = [
    kubernetes_namespace.app
  ]
}
