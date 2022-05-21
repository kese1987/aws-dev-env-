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