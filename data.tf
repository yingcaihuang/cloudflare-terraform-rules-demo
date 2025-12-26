# Data source to get available phases
data "cloudflare_rulesets" "available_phases" {
  zone_id = var.cloudflare_zone_id
}

# Data source to get managed rulesets information
data "cloudflare_rulesets" "managed_rulesets" {
  zone_id = var.cloudflare_zone_id
}

# Output to see all available phases
output "available_phases" {
  description = "All available phases in the zone"
  value = distinct([
    for ruleset in data.cloudflare_rulesets.available_phases.rulesets : ruleset.phase
  ])
}

# Output to see managed rulesets specifically
output "managed_rulesets_info" {
  description = "Information about managed rulesets"
  value = [
    for ruleset in data.cloudflare_rulesets.managed_rulesets.rulesets : {
      id          = ruleset.id
      name        = ruleset.name
      phase       = ruleset.phase
      kind        = ruleset.kind
      description = ruleset.description
    }
    if ruleset.kind == "managed" || (ruleset.kind == "zone" && can(regex("managed|firewall", ruleset.phase)))
  ]
}

# Local values for commonly used phases
locals {
  phases = {
    custom_firewall  = "http_request_firewall_custom"
    managed_firewall = "http_request_firewall_managed"
    rate_limit      = "http_ratelimit"
    ddos_l7         = "ddos_l7"
    transform       = "http_request_transform"
    origin          = "http_request_origin"
    cache_settings  = "http_request_cache_settings"
  }
  
  # Find existing managed WAF ruleset
  managed_waf_ruleset = [
    for ruleset in data.cloudflare_rulesets.managed_rulesets.rulesets : ruleset
    if ruleset.phase == local.phases.managed_firewall && ruleset.kind == "zone"
  ][0]
}