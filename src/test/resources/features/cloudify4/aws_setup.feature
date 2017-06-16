Feature: Configure cloudify 4 orchestrator

  Scenario: Setup cloudify orchestrator
    Given I am authenticated with "ADMIN" role
    # Create orchestrator
    And I create an orchestrator named "cfy" and plugin name "alien-cloudify-4-orchestrator-premium" and bean name "cloudify-orchestrator"
    And I get configuration for orchestrator "cfy"
    And I update configuration for orchestrator with name "cfy"
      | url                    | CFY_MANAGER_URL      |
      | userName               | CFY_MANAGER_USER     |
      | password               | CFY_MANAGER_PASSWORD |
      | disableSSLVerification | true                 |
    And I enable the orchestrator "cfy"
    # Create location
    And I create a location named "aws" and infrastructure type "amazon" to the orchestrator "cfy"
    # Configure small flavor resource
    And I create a resource of type "alien.cloudify.aws.nodes.InstanceType" named "Small" related to the location "cfy"/"aws"
    And I update the property "id" to "t2.small" for the resource named "Small" related to the location "cfy"/"aws"
    # Create ubuntu image resource
    And I create a resource of type "alien.cloudify.aws.nodes.Image" named "Ubuntu" related to the location "cfy"/"aws"
    And I update the property "id" to "ami-47a23a30" for the resource named "Ubuntu" related to the location "cfy"/"aws"
    And I update the capability "os" property "architecture" to "x86_64" for the resource named "Ubuntu" related to the location "cfy"/"aws"
    And I update the capability "os" property "type" to "linux" for the resource named "Ubuntu" related to the location "cfy"/"aws"
    And I update the capability "os" property "distribution" to "ubuntu" for the resource named "Ubuntu" related to the location "cfy"/"aws"
    And I update the capability "os" property "version" to "14" for the resource named "Ubuntu" related to the location "cfy"/"aws"
    # Generate computes
    And I autogenerate the on-demand resources for the location "cfy"/"aws"
    # Configure security groups
    And I update the complex property "parameters" to """{"security_group_ids": ["sg-81001bf8","sg-cffd98b6"]}""" for the resource named "Small_Ubuntu" related to the location "cfy"/"aws"
