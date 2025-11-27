# 1. Création de l'API Gateway (Type HTTP)
resource "aws_apigatewayv2_api" "api" {
  name          = var.name
  protocol_type = "HTTP"
}

# 2. Création de l'étape de déploiement (Stage) par défaut
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default" # Signifie que les changements sont effectifs immédiatement
  auto_deploy = true
}

# 3. Connexion (Intégration) entre l'API et ta Lambda
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.api.id
  integration_type = "AWS_PROXY"
  integration_uri  = var.function_arn
  
  # Format v2.0 est recommandé pour les nouvelles APIs HTTP
  payload_format_version = "2.0"
}

# 4. Création des Routes (ex: "GET /")
# On boucle sur la variable 'api_gateway_routes' pour créer chaque route demandée
resource "aws_apigatewayv2_route" "routes" {
  for_each = toset(var.api_gateway_routes)

  api_id    = aws_apigatewayv2_api.api.id
  route_key = each.key
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# 5. PERMISSIONS CRITIQUES : Autoriser l'API Gateway à appeler la Lambda
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.function_arn
  principal     = "apigateway.amazonaws.com"

  # On restreint pour que SEULE cette API puisse invoquer la Lambda
  source_arn = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}