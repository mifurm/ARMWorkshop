resource "azurerm_policy_definition" "policy" {
  name         = "accTestPolicy"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "acceptance test policy definition"

  metadata = <<METADATA
    {
    "category": "General"
    }
METADATA

 policy_rule = <<POLICY_RULE
         "if": {
            "not": {
               "field": "location",
               "in": [
                  "northeurope",
                  "westeurope", 
                  "francesouth",
                  "francecentral",
                  "norwaywest",
                  "francesouth",
                  "germanynorth",
                  "germanywestcentral",
                  "norwaywest",
                  "norwayeast" 
               ]
            }
         },
         "then": {
            "effect": "Deny"
         }
POLICY_RULE

}
