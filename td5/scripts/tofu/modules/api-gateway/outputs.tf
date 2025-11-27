output "api_endpoint" {
  description = "L'URL publique de l'API Gateway"
  value       = aws_apigatewayv2_stage.default.invoke_url
}