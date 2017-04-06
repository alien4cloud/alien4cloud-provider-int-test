Feature: Deletable block storage
  # Tested features with this scenario:
  #   - Deletable block storage
  Scenario: Block storage
    Given I am authenticated with "ADMIN" role

    # Archives
    And I checkout the git archive from url "https://github.com/alien4cloud/tosca-normative-types.git" branch "1.2.0"
    And I upload the git archive "tosca-normative-types"
    And I checkout the git archive from url "https://github.com/alien4cloud/alien4cloud-extended-types.git" branch "1.3.0"
    And I upload the local archive "topologies/deletable_block_storage.yaml"

    # Cloudify 3
    And I upload a plugin from maven artifact "alien4cloud:alien4cloud-cloudify4-provider"
    # And I upload a plugin from "../alien4cloud-cloudify4-provider"

    # Orchestrator and location
    And I create an orchestrator named "Mount doom orchestrator" and plugin name "alien-cloudify-4-orchestrator" and bean name "cloudify-orchestrator"
    And I get configuration for orchestrator "Mount doom orchestrator"
    And I update cloudify 3 manager's url to value defined in environment variable "OPENSTACK_CLOUDIFY3_MANAGER_URL" for orchestrator with name "Mount doom orchestrator"
    And I enable the orchestrator "Mount doom orchestrator"
    And I create a location named "Thark location" and infrastructure type "openstack" to the orchestrator "Mount doom orchestrator"
    And I create a resource of type "alien.nodes.openstack.Flavor" named "Small" related to the location "Mount doom orchestrator"/"Thark location"
    And I update the property "id" to "2" for the resource named "Small" related to the location "Mount doom orchestrator"/"Thark location"
    And I create a resource of type "alien.nodes.openstack.Image" named "Ubuntu" related to the location "Mount doom orchestrator"/"Thark location"
    And I update the property "id" to "02ddfcbb-9534-44d7-974d-5cfd36dfbcab" for the resource named "Ubuntu" related to the location "Mount doom orchestrator"/"Thark location"
    And I autogenerate the on-demand resources for the location "Mount doom orchestrator"/"Thark location"
    And I update the property "user" to "ubuntu" for the resource named "Small_Ubuntu" related to the location "Mount doom orchestrator"/"Thark location"
    And I create a resource of type "alien.cloudify.openstack.nodes.DeletableVolume" named "DeletableVolume" related to the location "Mount doom orchestrator"/"Thark location"
    And I update the property "size" to "1 gib" for the resource named "DeletableVolume" related to the location "Mount doom orchestrator"/"Thark location"

    And I create a new application with name "block-storage-cfy3" and description "Block Storage with CFY 3" based on the template with name "DeletableVolume"
    And I Set a unique location policy to "Mount doom orchestrator"/"Thark location" for all nodes

    When I deploy it
    Then I should receive a RestResponse with no error
    And The application's deployment must succeed after 15 minutes
    Then I should have a volume on OpenStack with id defined in runtime property "external_id" of the node "BlockStorage"
    When I undeploy it
    Then I should not have a volume on OpenStack with id defined in runtime property "external_id" of the node "BlockStorage"