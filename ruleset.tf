# Terraform Cloudflare Ruleset Example

# 1. Zone Custom Firewall Rules (directly visible in interface)

resource "cloudflare_ruleset" "zone_custom_firewall_entrypoint" {
  zone_id     = var.cloudflare_zone_id
  name        = "default"
  description = ""
  kind        = "zone"
  phase       = "http_request_firewall_custom"

  rules = [
    {
      description = "custom_acl_v1"
      expression  = "(ip.src.country eq \"AX\")"
      action      = "block"
      action_parameters = {
        response = {
          status_code  = 403
          content_type = "text/html"
          content      = "go away"
        }
      }
    }
  ]
}

# 2. Rate Limiting Ruleset

resource "cloudflare_ruleset" "rate_limiting" {
  zone_id     = var.cloudflare_zone_id
  name        = "rate_limiting"
  description = "Rate limiting for mytv163 user agent"
  kind        = "zone"
  phase       = "http_ratelimit"

  rules = [
    {
      description = "new_rate_limiting_rule"
      expression  = "(http.user_agent wildcard r\"mytv163\")"
      action      = "block"
      enabled     = true
      ratelimit = {
        characteristics     = ["cf.colo.id", "ip.src"]
        period             = 15
        requests_per_period = 10
        mitigation_timeout  = 600
      }
    }
  ]
}

# 3. Managed Rules Exception (skip managed rules for specific conditions)

resource "cloudflare_ruleset" "managed_rules_exception" {
  zone_id     = var.cloudflare_zone_id
  name        = "Zone-level Managed WAF"
  description = "Deploy Cloudflare Managed Ruleset at zone level"
  kind        = "zone"
  phase       = "http_request_firewall_managed"

  rules = [
    {
      description = "auto-custom-deploy-managed-rules"
      expression  = "(ip.src.country eq \"AX\")"
      action      = "skip"
      action_parameters = {
        ruleset = "current"
      }
    }
  ]
}
