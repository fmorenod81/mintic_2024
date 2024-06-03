#resource "aws_ec2_instance_state" "test" {
#  instance_id = var.instance_id
#  state       = "running" #state - (Required) - State of the instance. Valid values are stopped, running.
#}



resource "null_resource" "reboo_instance" {

  provisioner "local-exec" {
    interpreter = ["cmd"]
    command     = <<EOT
        echo -e "\x1B[31m Warning! Restarting instance having id ${var.instance_id}.................. \x1B[0m"
        # To stop instance
        aws ec2 stop-instances --instance-ids ${var.instance_id} --profile l1group
        echo "***************************************Rebooted****************************************************"
     EOT
  }
#   this setting will trigger script every time,change it something needed
  triggers = {
    always_run = "${timestamp()}"
  }
}