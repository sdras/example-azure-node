workflow "New workflow" {
  on = "push"
  resolves = ["Deploy to Azure"]
}

action "Deploy to Azure" {
  uses = "./.github/azdeploy"
  secrets = ["SERVICE_PASS"]
  env = {
    SERVICE_PRINCIPAL="http://sdrasApp",
    TENANT_ID="72f988bf-86f1-41af-91ab-2d7cd011db47",
    APPID="sdrasMoonshine"
  }
}