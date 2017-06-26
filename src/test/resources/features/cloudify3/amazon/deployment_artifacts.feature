Feature: Usage of deployment artifacts with cloudify 3
  # Tested features with this scenario:
  #   - Deployment artifact as a file and directory for nodes and relationships
  #   - Override deployment artifact in Alien
  Scenario: Usage of deployment artifacts with cloudify 3
    Given I am authenticated with "ADMIN" role

    # Archives
    And I checkout the git archive from url "https://github.com/alien4cloud/tosca-normative-types.git" branch "master"
    And I upload the git archive "tosca-normative-types"
    And I checkout the git archive from url "https://github.com/alien4cloud/alien4cloud-extended-types.git" branch "master"
    And I successfully upload the local archive "csars/artifact-test"
    And I successfully upload the local archive "topologies/artifact_test"

    # Cloudify 3
    And I upload a plugin from maven artifact "alien4cloud:alien4cloud-cloudify4-provider"
#    And I upload a plugin from "../alien4cloud-cloudify4-provider"

    # Orchestrator and location
    And I create an orchestrator named "Mount doom orchestrator" and plugin name "alien-cloudify-4-orchestrator" and bean name "cloudify-orchestrator"
    And I get configuration for orchestrator "Mount doom orchestrator"
    And I update cloudify 3 manager's url to value defined in environment variable "AWS_CLOUDIFY3_MANAGER_URL" for orchestrator with name "Mount doom orchestrator"
    And I successfully enable the orchestrator "Mount doom orchestrator"
    And I create a location named "Thark location" and infrastructure type "amazon" to the orchestrator "Mount doom orchestrator"
    And I create a resource of type "alien.cloudify.aws.nodes.InstanceType" named "Small" related to the location "Mount doom orchestrator"/"Thark location"
    And I update the property "id" to "t2.small" for the resource named "Small" related to the location "Mount doom orchestrator"/"Thark location"
    And I create a resource of type "alien.cloudify.aws.nodes.Image" named "Ubuntu" related to the location "Mount doom orchestrator"/"Thark location"
    And I update the property "id" to "ami-47a23a30" for the resource named "Ubuntu" related to the location "Mount doom orchestrator"/"Thark location"
    And I autogenerate the on-demand resources for the location "Mount doom orchestrator"/"Thark location"
    And I create a resource of type "alien.nodes.aws.PublicNetwork" named "Internet" related to the location "Mount doom orchestrator"/"Thark location"

    And I create a new application with name "artifact-test-cfy3" and description "Artifact test with CFY 3" based on the template with name "artifact_test"
    And I Set a unique location policy to "Mount doom orchestrator"/"Thark location" for all nodes
    And I upload a file located at "src/test/resources/data/toOverride.txt" to the archive path "toOverride.txt"
    And I execute the operation
      | type              | org.alien4cloud.tosca.editor.operations.nodetemplate.UpdateNodeDeploymentArtifactOperation |
      | nodeName          | Artifacts                                                                                  |
      | artifactName      | to_be_overridden                                                                           |
      | artifactReference | toOverride.txt                                                                             |
    And I save the topology
    When I deploy it
    Then I should receive a RestResponse with no error
    And The application's deployment must succeed after 15 minutes

      # test preserved deployment artifats
    When I download the remote file "/home/ubuntu/Artifacts/toBePreserved.txt" from the node "Compute" with the keypair defined in environment variable "AWS_KEY_PATH" and user "ubuntu"
    Then The downloaded file should have the same content as the local file "csars/artifact-test/toBePreserved.txt"
    When I download the remote file "/home/ubuntu/ArtifactsYamlOverride/toBePreserved.txt" from the node "Compute" with the keypair defined in environment variable "AWS_KEY_PATH" and user "ubuntu"
    Then The downloaded file should have the same content as the local file "csars/artifact-test/toBePreserved.txt"

    # test overridding from Alien4cloud
    When I download the remote file "/home/ubuntu/Artifacts/toOverride.txt" from the node "Compute" with the keypair defined in environment variable "AWS_KEY_PATH" and user "ubuntu"
    Then The downloaded file should have the same content as the local file "data/toOverride.txt"

    #test overridding from yaml topology csar
    When I download the remote file "/home/ubuntu/ArtifactsYamlOverride/toOverrideFromYaml.txt" from the node "Compute" with the keypair defined in environment variable "AWS_KEY_PATH" and user "ubuntu"
    Then The downloaded file should have the same content as the local file "topologies/artifact_test/toOverrideFromYaml.txt"

    #test artifacts of the relationship
    When I download the remote file "/home/ubuntu/relationship/ArtifactsYamlOverride/settingsRel.properties" from the node "Compute" with the keypair defined in environment variable "AWS_KEY_PATH" and user "ubuntu"
    Then The downloaded file should have the same content as the local file "csars/artifact-test/settingsRel.properties"
