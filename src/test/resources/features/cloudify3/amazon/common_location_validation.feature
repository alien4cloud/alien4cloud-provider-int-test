Feature: Common tests on location management for the Cfy orchestrator

  # Tested feature with this scenario:
  #   - We cannot create multiple location on the same orchestrator
#  Scenario: Multiple location support
#    Given I am authenticated with "ADMIN" role
#
#    # Archives
#    And I checkout the git archive from url "https://github.com/alien4cloud/tosca-normative-types.git" branch "master"
#    And I upload the git archive "tosca-normative-types"
#
#    # Cloudify 3
#    And I upload a plugin from maven artifact "alien4cloud:alien4cloud-cloudify4-provider"
#    #And I upload a plugin from "../alien4cloud-cloudify4-provider"
#
#    # Orchestrator and location
#    And I create an orchestrator named "Mount doom orchestrator" and plugin name "alien-cloudify-4-orchestrator" and bean name "cloudify-orchestrator"
#    And I get configuration for orchestrator "Mount doom orchestrator"
#    And I update cloudify 3 manager's url to value defined in environment variable "AWS_CLOUDIFY3_MANAGER_URL" for orchestrator with name "Mount doom orchestrator"
#    And I enable the orchestrator "Mount doom orchestrator"
#    And I create a location named "Thark location" and infrastructure type "amazon" to the orchestrator "Mount doom orchestrator"
#    Then I should receive a RestResponse with no error
#    And I create a location named "Thark location 2" and infrastructure type "amazon" to the orchestrator "Mount doom orchestrator"
#    Then I should receive a RestResponse with an error code 376


  Scenario: Valid that an admin cannot delete a location if an application is deployed on it
    Given I am authenticated with "ADMIN" role

    # Archives
    And I checkout the git archive from url "https://github.com/alien4cloud/tosca-normative-types.git" branch "master"
    And I upload the git archive "tosca-normative-types"
    And I successfully upload the local archive "topologies/simple-compute-topology.yml"

    # Cloudify 3
    And I upload a plugin from maven artifact "alien4cloud:alien4cloud-cloudify4-provider"
    #And I upload a plugin from "../alien4cloud-cloudify4-provider"

    # Orchestrator and location
    And I create an orchestrator named "Mount doom orchestrator" and plugin name "alien-cloudify-4-orchestrator" and bean name "cloudify-orchestrator"
    And I get configuration for orchestrator "Mount doom orchestrator"
    And I update cloudify 3 manager's url to value defined in environment variable "AWS_CLOUDIFY3_MANAGER_URL" for orchestrator with name "Mount doom orchestrator"
    And I enable the orchestrator "Mount doom orchestrator"
    And I create a location named "Thark location" and infrastructure type "amazon" to the orchestrator "Mount doom orchestrator"
    And I create a resource of type "alien.cloudify.aws.nodes.InstanceType" named "Small" related to the location "Mount doom orchestrator"/"Thark location"
    And I update the property "id" to "t2.small" for the resource named "Small" related to the location "Mount doom orchestrator"/"Thark location"
    And I create a resource of type "alien.cloudify.aws.nodes.Image" named "Ubuntu" related to the location "Mount doom orchestrator"/"Thark location"
    And I update the property "id" to "ami-47a23a30" for the resource named "Ubuntu" related to the location "Mount doom orchestrator"/"Thark location"
    And I autogenerate the on-demand resources for the location "Mount doom orchestrator"/"Thark location"

    And I create a new application with name "simple-compute-cfy3" and description "Simple compute with CFY 3" based on the template with name "simple-compute"
    And I Set a unique location policy to "Mount doom orchestrator"/"Thark location" for all nodes
    When I deploy it
    Then I should receive a RestResponse with no error
    And The application's deployment must succeed after 15 minutes
    Then I delete a location with name "Thark location" to the orchestrator "Mount doom orchestrator"
    And I should receive a RestResponse with a boolean data "false"

