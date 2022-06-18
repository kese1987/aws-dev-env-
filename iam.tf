resource "aws_iam_user" "admin" {
  name          = "admin"
  force_destroy = "true"
}

resource "aws_iam_group" "administrators" {
  name = "administrators"
}
resource "aws_iam_group_membership" "users-member-of-administrators" {
  name  = "admin-users"
  users = [aws_iam_user.admin.name]
  group = aws_iam_group.administrators.name
}

resource "aws_iam_group_policy_attachment" "administrators-given-policy-fullaccess" {
  group      = aws_iam_group.administrators.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

##### eks cluster role
resource "aws_iam_role" "eksClusterRole" {
  name                = "eksClusterRole"
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"]
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : [
            "eks.amazonaws.com"
          ]
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = {
    tag-key = "eksClusterRole"
  }
}