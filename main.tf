# Checkout messaging infrastructure for the ShopNest checkout service.
#
# These queues carry checkout domain events. Each queue is paired with a
# dead-letter queue. The blocks below were originally created by copying a
# single queue definition and editing the names. A recent change introduced
# a workspace prefix on the queue names.
#
# Existing production queue names (already live, must remain stable):
#   orders-created / orders-created-dlq
#   payments-captured / payments-captured-dlq
#   inventory-reserved / inventory-reserved-dlq


# ------------------------------------------------------------

module "orders_created" {
  source = "./modules/sqs_queue"

  queue_name = "${terraform.workspace}-orders-created"
  max_receive_count = 5

  tags = {
    Service     = "checkout"
    Environment = terraform.workspace
    CostCenter  = "ecom-checkout"
  }
}

module "payments_captured" {
  source = "./modules/sqs_queue"

  queue_name = "${terraform.workspace}-payments-captured"
  max_receive_count = 3

  tags = {
      Service     = "checkout"
      Environment = terraform.workspace
      CostCenter  = "ecom-checkout"
  }
}

module "inventory_reserved" {
  source = "./modules/sqs_queue"

  queue_name = "${terraform.workspace}-inventory-reserved"
  max_receive_count = 10

  tags = {
    Service     = "checkout"
    Environment = terraform.workspace
    CostCenter  = "ecom-checkout"
  }
}

moved {
  from = aws_sqs_queue.orders_created
  to = module.orders_created.aws_sqs_queue.main
}

moved {
  from = aws_sqs_queue.orders_created_dlq
  to = module.orders_created.aws_sqs_queue.dlq
}

moved {
  from = aws_sqs_queue.payments_captured
  to = module.payments_captured.aws_sqs_queue.main
}

moved {
  from = aws_sqs_queue.payments_captured_dlq
  to = module.payments_captured.aws_sqs_queue.dlq
}

moved {
  from = aws_sqs_queue.inventory_reserved
  to = module.inventory_reserved.aws_sqs_queue.main
}

moved {
  from = aws_sqs_queue.inventory_reserved_dlq
  to = module.inventory_reserved.aws_sqs_queue.dlq
}