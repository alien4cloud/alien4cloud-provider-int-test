Feature: Configure cloudify 4 orchestrator

  Scenario: Load required archives from git
    Given I am authenticated with "ADMIN" role
    # Create orchestrator
    And I create an orchestrator named "cfy" and plugin name "alien-cloudify-4-orchestrator" and bean name "cloudify-orchestrator"
    And I get configuration for orchestrator "cfy"
    And I update cloudify 3 manager's url to value defined in environment variable "CFY_MANAGER_URL" for orchestrator with name "cfy"
    And I enable the orchestrator "cfy"
    # Create location
    And I create a location named "aws" and infrastructure type "amazon" to the orchestrator "cfy"
    # Configure small flavor resource
    And I create a resource of type "alien.cloudify.aws.nodes.InstanceType" named "Small" related to the location "cfy"/"aws"
    And I update the property "id" to "t2.small" for the resource named "Small" related to the location "cfy"/"aws"
    # Create ubuntu image resource
    And I create a resource of type "alien.cloudify.aws.nodes.Image" named "Ubuntu" related to the location "cfy"/"aws"
    And I update the property "id" to "ami-47a23a30" for the resource named "Ubuntu" related to the location "cfy"/"aws"
    # Generate computes
    And I autogenerate the on-demand resources for the location "cfy"/"aws"
