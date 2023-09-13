app_name="sam-bicky"
env_name="prod"
region="ca-central-1"
cidr="10.0.0.0/16"
#azs=["${var.region}-a","${var.region}-b","${var.region}-c"]
public_subnets=["10.0.1.0/24","10.0.2.0/24"]
private_subnets=["10.0.101.0/24","10.0.102.0/24"]
