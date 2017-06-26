Feature: Update Topology Deployment Failure

  Background:
    Given I am authenticated with "ADMIN" role

    # Archives
    And I checkout the git archive from url "https://github.com/alien4cloud/tosca-normative-types.git" branch "master"
    And I upload the git archive "tosca-normative-types"
    And I checkout the git archive from url "https://github.com/alien4cloud/tosca-normative-types.git" branch "master"
    And I upload the git archive "tosca-normative-types"
    And I checkout the git archive from url "https://github.com/alien4cloud/alien4cloud-extended-types.git" branch "master"
    And I upload the git archive "alien4cloud-extended-types/alien-base-types"
    And I upload the git archive "alien4cloud-extended-types/alien-extended-storage-types"
    And I checkout the git archive from url "https://github.com/alien4cloud/samples.git" branch "master"
    And I upload the git archive "samples/apache"
    And I upload the git archive "samples/php"
    And I upload the git archive "samples/mongo"

    # Cloudify 3
    And I upload a plugin from maven artifact "alien4cloud:alien4cloud-cloudify4-provider"
    # And I upload a plugin from "../alien4cloud-cloudify4-provider"

    # Orchestrator and location
    And I create an orchestrator named "Mount doom orchestrator" and plugin name "alien-cloudify-4-orchestrator" and bean name "cloudify-orchestrator"
    And I get configuration for orchestrator "Mount doom orchestrator"
    And I update cloudify 3 manager's url to value defined in environment variable "AWS_CLOUDIFY3_MANAGER_URL" for orchestrator with name "Mount doom orchestrator"
    And I successfully enable the orchestrator "Mount doom orchestrator"
    And I create a location named "Thark location" and infrastructure type "amazon" to the orchestrator "Mount doom orchestrator"
    And I create a resource of type "alien.cloudify.aws.nodes.InstanceType" named "Small" related to the location "Mount doom orchestrator"/"Thark location"
    And I update the property "id" to "t2.nano" for the resource named "Small" related to the location "Mount doom orchestrator"/"Thark location"
    And I create a resource of type "alien.cloudify.aws.nodes.Image" named "Ubuntu" related to the location "Mount doom orchestrator"/"Thark location"
    And I update the property "id" to "ami-47a23a30" for the resource named "Ubuntu" related to the location "Mount doom orchestrator"/"Thark location"
    And I autogenerate the on-demand resources for the location "Mount doom orchestrator"/"Thark location"
    And I create a resource of type "alien.nodes.aws.PublicNetwork" named "Internet" related to the location "Mount doom orchestrator"/"Thark location"

  Scenario: Change a node type should fail
    Given I am authenticated with "ADMIN" role
    And I upload the local archive "topologies/updatable-topology-fail-initial.yml"
    And I create a new application with name "updatableappFailure" and description "First version of my application with apache" based on the template with name "UpdatableTopologyFailInitial"
    And I Set a unique location policy to "Mount doom orchestrator"/"Thark location" for all nodes
    And I deploy it
    And I should receive a RestResponse with no error
    And The application's deployment must succeed after 15 minutes
    And I upload the local archive "topologies/updatable-topology-fail-type-updated.yml"
    And I create an application version for application "updatableappFailure" with version "0.2.0-SNAPSHOT", description "A new version where Apache is now for type is now mongo.", topology template id "UpdatableTopologyFailTypeUpdated:0.1.0-SNAPSHOT" and previous version id "null"
    And I should receive a RestResponse with no error
    And I update the application environment named "Environment" with values
      | currentVersionId | 0.2.0-SNAPSHOT |
    And I Set a unique location policy to "Mount doom orchestrator"/"Thark location" for all nodes
    And I update the deployment
    And The deployment update should fail

  Scenario: Add a scalable compute should fail
    Given I am authenticated with "ADMIN" role
    And I upload the local archive "topologies/updatable-topology-fail-initial.yml"
    And I create a new application with name "updatableappFailure" and description "First version of my application with apache" based on the template with name "UpdatableTopologyFailInitial"
    And I Set a unique location policy to "Mount doom orchestrator"/"Thark location" for all nodes
    And I deploy it
    And I should receive a RestResponse with no error
    And The application's deployment must succeed after 15 minutes
    And I upload the local archive "topologies/updatable-topology-fail-scalable.yml"
    And I create an application version for application "updatableappFailure" with version "0.2.0-SNAPSHOT", description "A new version where a scalable compute is added.", topology template id "UpdatableTopologyFailScalable:0.1.0-SNAPSHOT" and previous version id "null"
    And I should receive a RestResponse with no error
    And I update the application environment named "Environment" with values
      | currentVersionId | 0.2.0-SNAPSHOT |
    And I Set a unique location policy to "Mount doom orchestrator"/"Thark location" for all nodes
    And I update the deployment
    And The deployment update should fail

  Scenario: Change an hostedOn should fail
    Given I am authenticated with "ADMIN" role
    And I upload the local archive "topologies/updatable-topology-fail-initial.yml"
    And I create a new application with name "updatableappFailure" and description "First version of my application with apache" based on the template with name "UpdatableTopologyFailInitial"
    And I Set a unique location policy to "Mount doom orchestrator"/"Thark location" for all nodes
    And I deploy it
    And I should receive a RestResponse with no error
    And The application's deployment must succeed after 15 minutes
    And I upload the local archive "topologies/updatable-topology-fail-change-hostedon.yml"
    And I create an application version for application "updatableappFailure" with version "0.2.0-SNAPSHOT", description "A new version where a hostedOn has been changed.", topology template id "UpdatableTopologyFailChangeHostedOn:0.1.0-SNAPSHOT" and previous version id "null"
    And I should receive a RestResponse with no error
    And I update the application environment named "Environment" with values
      | currentVersionId | 0.2.0-SNAPSHOT |
    And I Set a unique location policy to "Mount doom orchestrator"/"Thark location" for all nodes
    And I update the deployment
    And The deployment update should fail
