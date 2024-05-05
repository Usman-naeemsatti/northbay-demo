resource "aws_emr_cluster" "cluster" {
  name          = "emr-test-arn"
  release_label = "emr-4.6.0"
  applications  = ["Spark"]

  ec2_attributes {
    instance_profile                  = aws_iam_instance_profile.emr_instance_profile.arn
  }

  master_instance_group {
    instance_type = "c1.medium"
  }

  core_instance_group {
    instance_type  = "c1.medium"
    instance_count = 1
    
  }

#   bootstrap_action {
#     path = "s3://elasticmapreduce/bootstrap-actions/run-if"
#     name = "runif"
#     args = ["instance.isMaster=true", "echo running on master node"]
#   }

  service_role = aws_iam_role.emr_service_role.arn

  depends_on = [ aws_api_gateway_deployment.prod ]

}