Feature: Common tests on location management for the Cfy orchestrator

  # Tested feature with this scenario:
  #   - We cannot create multiple location on the same orchestrator
  Scenario: Multiple location support
    Given I am authenticated with "ADMIN" role

    # Archives
    And I checkout the git archive from url "https://github.com/alien4cloud/tosca-normative-types.git" branch "master"
    And I upload the git archive "tosca-normative-types"

    # Cloudify 3
    And I upload a plugin from maven artifact "alien4cloud:alien4cloud-cloudify4-provider"
#    And I upload a plugin from "../alien4cloud-cloudify4-provider"

    # Orchestrator and location
    And I create an orchestrator named "Mount doom orchestrator" and plugin name "alien-cloudify-4-orchestrator" and bean name "cloudify-orchestrator"
    And I get configuration for orchestrator "Mount doom orchestrator"
    And I update cloudify 3 manager's url to value defined in environment variable "AWS_CLOUDIFY3_MANAGER_URL" for orchestrator with name "Mount doom orchestrator"
    And I enable the orchestrator "Mount doom orchestrator"
    And I create a location named "Thark location" and infrastructure type "amazon" to the orchestrator "Mount doom orchestrator"
    Then I should receive a RestResponse with no error
    And I create a location named "Thark location 2" and infrastructure type "amazon" to the orchestrator "Mount doom orchestrator"
    Then I should receive a RestResponse with an error code 376
