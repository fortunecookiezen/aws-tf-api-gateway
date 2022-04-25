
module "private_api_gw" {
  source              = "../"
  name                = "example"
  target_loadbalancer = aws_lb.example.arn
  uri                 = "https://api.bibelobis.com"
}

resource "aws_lb" "example" {
  name_prefix        = "nope-"
  internal           = true
  ip_address_type    = "ipv4"
  load_balancer_type = "network"
  subnets = [
    "subnet-0eaef3c189b011e82",
    "subnet-01ce6daab45a46155",
    "subnet-03da9656d7bc1b284",
    "subnet-0eee99838d4a10c8b"
  ]
}
