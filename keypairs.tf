resource "aws_key_pair" "keypairs" {

  for_each = local.known-key-pairs

  key_name   = each.value.key-name
  public_key = each.value.public-key
}
