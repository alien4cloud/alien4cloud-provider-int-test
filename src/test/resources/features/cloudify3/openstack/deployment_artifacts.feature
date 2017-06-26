Feature: Usage of deployment artifacts with cloudify 3
  # Tested features with this scenario:
  #   - Deployment artifact as a file and directory for nodes and relationships
  #   - Override deployment artifact in Alien
  #   - Override node deployment artifact in imported yaml topology csar
  #   - Complex property usage with get_property
  Scenario: Usage of deployment artifacts with cloudify 3
    Given I am authenticated with "ADMIN" role

    # Archives
    And I checkout the git archive from url "https://github.com/alien4cloud/tosca-normative-types.git" branch "master"
    And I upload the git archive "tosca-normative-types"
    And I checkout the git archive from url "https://github.com/alien4cloud/alien4cloud-extended-types.git" branch "master"
    And I upload the local archive "csars/artifact-test"
    And I upload the local archive "topologies/artifact_test"

    # Cloudify 3
    And I upload a plugin from maven artifact "alien4cloud:alien4cloud-cloudify4-provider"
#    And I upload a plugin from "../alien4cloud-cloudify4-provider"
#    And I upload a plugin "alien4cloud-cloudify4-provider" from "/home/igor/WKS/A4C/a4c-cdfy3"

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
    And I create a resource of type "alien.nodes.openstack.PublicNetwork" named "Internet" related to the location "Mount doom orchestrator"/"Thark location"
    And I update the complex property "floatingip" to """{"floating_network_name": "net-pub"}""" for the resource named "Internet" related to the location "Mount doom orchestrator"/"Thark location"
    And I update the complex property "server" to """{"security_groups": ["openbar"]}""" for the resource named "Small_Ubuntu" related to the location "Mount doom orchestrator"/"Thark location"
    And I update the property "user" to "ubuntu" for the resource named "Small_Ubuntu" related to the location "Mount doom orchestrator"/"Thark location"

    And I create a new application with name "artifact-test-cfy3" and description "Artifact test with CFY 3" based on the template with name "artifact_test"
    And I Set a unique location policy to "Mount doom orchestrator"/"Thark location" for all nodes
    When I upload a file located at "src/test/resources/data/toOverride.txt" to the archive path "data/toBeOverridden.txt"
    Then I should receive a RestResponse with no error
    When I execute the operation
      | type              | org.alien4cloud.tosca.editor.operations.nodetemplate.UpdateNodeDeploymentArtifactOperation |
      | nodeName          | Artifacts                                                                                  |
      | artifactName      | to_be_overridden                                                                           |
      | artifactReference | data/toBeOverridden.txt                                                                    |
    Then I should receive a RestResponse with no error
    And I save the topology
    When I deploy it
    Then I should receive a RestResponse with no error
    And The application's deployment must succeed after 15 minutes


    # test preserved deployment artifats
    When I download the remote file "/home/ubuntu/Artifacts/toBePreserved.txt" from the node "Compute" with the keypair "keys/openstack/alien.pem" and user "ubuntu"
    Then The downloaded file should have the same content as the local file "csars/artifact-test/toBePreserved.txt"
    When I download the remote file "/home/ubuntu/ArtifactsYamlOverride/toBePreserved.txt" from the node "Compute" with the keypair "keys/openstack/alien.pem" and user "ubuntu"
    Then The downloaded file should have the same content as the local file "csars/artifact-test/toBePreserved.txt"

    # test overridding from Alien4cloud
    When I download the remote file "/home/ubuntu/Artifacts/toBeOverridden.txt" from the node "Compute" with the keypair "keys/openstack/alien.pem" and user "ubuntu"
    Then The downloaded file should have the same content as the local file "data/toOverride.txt"

    #test overridding from yaml topology csar
    When I download the remote file "/home/ubuntu/ArtifactsYamlOverride/toOverrideFromYaml.txt" from the node "Compute" with the keypair "keys/openstack/alien.pem" and user "ubuntu"
    Then The downloaded file should have the same content as the local file "topologies/artifact_test/toOverrideFromYaml.txt"

    #test artifacts of the relationship
    When I download the remote file "/home/ubuntu/relationship/ArtifactsYamlOverride/settingsRel.properties" from the node "Compute" with the keypair "keys/openstack/alien.pem" and user "ubuntu"
    Then The downloaded file should have the same content as the local file "csars/artifact-test/settingsRel.properties"
