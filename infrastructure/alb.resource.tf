data "aws_vpc" "vpc" {
  default = true
}

data "aws_subnet_ids" "subnets" {
  vpc_id = data.aws_vpc.vpc.id
}

resource "aws_lb" "lb" {
  name               = "ab"
  internal           = true
  load_balancer_type = "application"

  subnets = tolist(data.aws_subnet_ids.subnets.ids)

  enable_http2               = true

  tags = local.tags
}

resource "aws_lb_listener" "lb_l" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Resource not found"
      status_code  = "404"
    }
  }
}

# ----------

resource "aws_lb_target_group" "tg-decision" {
  target_type = "lambda"
  name        = "tg-decision"
  tags        = local.tags
}

resource "aws_lambda_permission" "lbd-decision" {
  statement_id  = "AllowExecutionFromlb"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lbd-decision.function_name
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.tg-decision.arn
}

resource "aws_lb_target_group_attachment" "tga-decision" {
  depends_on       = [aws_lambda_permission.lbd-decision]
  target_group_arn = aws_lb_target_group.tg-decision.arn
  target_id        = aws_lambda_function.lbd-decision.arn
}

resource "aws_lb_listener_rule" "lr-decision" {
  listener_arn = aws_lb_listener.lb_l.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-decision.arn
  }

  condition {
    path_pattern {
      values = ["/api/decision"]
    }
  }

  condition {
    http_request_method {
      values = ["POST", "PATCH"]
    }
  }
}

# ----------

resource "aws_lb_target_group" "tg-statistics" {
  target_type = "lambda"
  name        = "tg-statistics"
  tags        = local.tags
}

resource "aws_lambda_permission" "lbd-statistics" {
  statement_id  = "AllowExecutionFromlb"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lbd-statistics.function_name
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.tg-statistics.arn
}

resource "aws_lb_target_group_attachment" "tga-statistics" {
  depends_on       = [aws_lambda_permission.lbd-statistics]
  target_group_arn = aws_lb_target_group.tg-statistics.arn
  target_id        = aws_lambda_function.lbd-statistics.arn
}

resource "aws_lb_listener_rule" "lr-statistics" {
  listener_arn = aws_lb_listener.lb_l.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-statistics.arn
  }

  condition {
    path_pattern {
      values = ["/api/statistics"]
    }
  }

  condition {
    http_request_method {
      values = ["GET"]
    }
  }
}
