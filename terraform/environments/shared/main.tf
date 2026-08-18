module "frontend" {
  source = "../../modules/frontend"

  environment   = "shared"
  frontend_path = "../../../frontend"
}