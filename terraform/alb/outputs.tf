output "aws_lb_listener_tfer--arn-003A-aws-003A-elasticloadbalancing-003A-us-east-1-003A-244996607989-003A-listener-002F-app-002F-Cream-balancer-002F-9fcccb60d4d06c46-002F-e7422b108d217e63_id" {
  value = "${aws_lb_listener.tfer--arn-003A-aws-003A-elasticloadbalancing-003A-us-east-1-003A-244996607989-003A-listener-002F-app-002F-Cream-balancer-002F-9fcccb60d4d06c46-002F-e7422b108d217e63.id}"
}

output "aws_lb_target_group_tfer--cream-task-tg_id" {
  value = "${aws_lb_target_group.tfer--cream-task-tg.id}"
}

output "aws_lb_tfer--Cream-balancer_id" {
  value = "${aws_lb.tfer--Cream-balancer.id}"
}
