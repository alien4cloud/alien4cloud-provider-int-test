Feature: Update Topology Deployment

  Background:
    Given I am authenticated with "ADMIN" role

    # Archives
    And I checkout the git archive from url "https://github.com/alien4cloud/tosca-normative-types.git" branch "1.2.0"
    And I upload the git archive "tosca-normative-types"
    And I checkout the git archive from url "https://github.com/alien4cloud/tosca-normative-types.git" branch "master"
    And I upload the git archive "tosca-normative-types"
    And I checkout the git archive from url "https://github.com/alien4cloud/alien4cloud-extended-types.git" branch "master"
    And I upload the git archive "alien4cloud-extended-types/alien-base-types"
    And I upload the git archive "alien4cloud-extended-types/alien-extended-storage-types"
    And I checkout the git archive from url "https://github.com/alien4cloud/samples.git" branch "master"
    And I upload the git archive "samples/apache"
    And I upload the git archive "samples/php"
    And I upload the git archive "samples/demo-lifecycle"
    And I upload the git archive "samples/mongo"

    # Cloudify 3
    #And I upload a plugin from maven artifact "alien4cloud:alien4cloud-cloudify4-provider"
    And I upload a plugin from "../alien4cloud-cloudify4-provider"

    # Orchestrator and location
    And I create an orchestrator named "Mount doom orchestrator" and plugin name "alien-cloudify-4-orchestrator" and bean name "cloudify-orchestrator"
    And I get configuration for orchestrator "Mount doom orchestrator"
    And I update cloudify 3 manager's url to value defined in environment variable "AWS_CLOUDIFY3_MANAGER_URL" for orchestrator with name "Mount doom orchestrator"
    And I enable the orchestrator "Mount doom orchestrator"
    And I create a location named "Thark location" and infrastructure type "amazon" to the orchestrator "Mount doom orchestrator"
    And I create a resource of type "alien.cloudify.aws.nodes.InstanceType" named "Small" related to the location "Mount doom orchestrator"/"Thark location"
    And I update the property "id" to "t2.nano" for the resource named "Small" related to the location "Mount doom orchestrator"/"Thark location"
    And I create a resource of type "alien.cloudify.aws.nodes.Image" named "Ubuntu" related to the location "Mount doom orchestrator"/"Thark location"
    And I update the property "id" to "ami-47a23a30" for the resource named "Ubuntu" related to the location "Mount doom orchestrator"/"Thark location"
    And I autogenerate the on-demand resources for the location "Mount doom orchestrator"/"Thark location"
    And I create a resource of type "alien.nodes.aws.PublicNetwork" named "Internet" related to the location "Mount doom orchestrator"/"Thark location"

    And I upload the local archive "topologies/topology-lifecycle-registry.yml"
    And I create a new application with name "lifecycle-registry" and description "Lifecycle registry" based on the template with name "lifecycle-registry"
    And I Set a unique location policy to "Mount doom orchestrator"/"Thark location" for all nodes
    And I deploy it
    And I should receive a RestResponse with no error
    And The application's deployment must succeed after 15 minutes
    And The URL which is defined in attribute "url" of the node "Registry" should work
    And I store the attribute "url" of the node "Registry" as registered string "registry_url"
    And I store the attribute "host" of the node "Registry" as registered string "registry_host"

  Scenario: Add a target and the relationship
    Given I am authenticated with "ADMIN" role
    And I upload the local archive "topologies/updatable-topology-S.yml"
    And I create a new application with name "updatableapp" and description "First version of my application only with source" based on the template with name "UpdatableTopologyS"
    And I Set a unique location policy to "Mount doom orchestrator"/"Thark location" for all nodes
    And I set the following inputs properties
      | registry_host | {{registry_host}} |
    And I deploy it
    And I should receive a RestResponse with no error
    And The application's deployment must succeed after 15 minutes
    And I upload the local archive "topologies/updatable-topology-STR.yml"
    And I create an application version for application "updatableapp" with version "0.2.0-SNAPSHOT", description "A new version with target and relationship.", topology template id "UpdatableTopologySTR:0.1.0-SNAPSHOT" and previous version id "null"
    And I should receive a RestResponse with no error
    And I update the application environment named "Environment" with values
      | currentVersionId | 0.2.0-SNAPSHOT |
    And I Set a unique location policy to "Mount doom orchestrator"/"Thark location" for all nodes
    And I set the following inputs properties
      | registry_host | {{registry_host}} |
    And I update the deployment
    And The deployment update should succeed after 15 minutes

    Given I call the URL which is defined in registered string "registry_url" with path "/get_instance_id.php?node=GenericHostS&idx=0" and fetch the response and store it in the context as "GenericHostS_0_id"
    And I call the URL which is defined in registered string "registry_url" with path "/get_instance_id.php?node=GenericS&idx=0" and fetch the response and store it in the context as "GenericS_0_id"
    And I call the URL which is defined in registered string "registry_url" with path "/get_instance_id.php?node=GenericT&idx=0" and fetch the response and store it in the context as "GenericT_0_id"

    # the target lifecycle operations has been called
    When I call the URL which is defined in registered string "registry_url" with path "/get_instance_log.php?node=GenericT&idx=0" and fetch the response and store it in the context as "GenericT_0_logs"
    Then the registered string "GenericT_0_logs" lines should match the following regex sequence
      | #\d+ - create |
      | #\d+ - pre_configure_source/GenericHostS/0/${GenericHostS_0_id} |
      | #\d+ - configure |
      | #\d+ - post_configure_source/GenericHostS/0/${GenericHostS_0_id} |
      | #\d+ - start |
      | #\d+ - add_target/GenericHostS/0/${GenericHostS_0_id} |
    And the registered string "GenericT_0_logs" lines should match the following regex sequence
      | #\d+ - start |
      | #\d+ - add_source/GenericS/0/${GenericS_0_id} |

    # ensure that the add_target has been called on the source of the relationship
    When I call the URL which is defined in registered string "registry_url" with path "/get_instance_log.php?node=GenericS&idx=0" and fetch the response and store it in the context as "GenericS_0_logs"
    Then the registered string "GenericS_0_logs" lines should match the following regex sequence
      | #\d+ - start |
      | #\d+ - add_target/GenericT/0/${GenericT_0_id} |

    # ensure that the property of the source has actually been changed
    When I can catch the following groups in one line of the registered string "GenericT_0_logs" and store them as registered strings
      | #(\d+) - add_source/GenericS/0/GenericS_.+ |
      | GenericT_0_addSource_GenericS_opIdx |
    And I expand the string "${registry_url}/get_env_log.php?idx=${GenericT_0_addSource_GenericS_opIdx}" and store it as "GenericT_0_addSource_GenericS_env_url" in the context
    And I call the URL which is defined in registered string "GenericT_0_addSource_GenericS_env_url" with path "" and fetch the response and store it in the context as "GenericT_0_addSource_GenericS_env"
    Then the following expanded regex should be found in the registered string "GenericT_0_addSource_GenericS_env"
      | ^SOURCE_PROPERTY=STR$ |

  Scenario: Remove the relationship
    Given I am authenticated with "ADMIN" role
    And I upload the local archive "topologies/updatable-topology-STR.yml"
    And I create a new application with name "updatableapp" and description "First version of my application with source, target and relationship" based on the template with name "UpdatableTopologySTR"
    And I Set a unique location policy to "Mount doom orchestrator"/"Thark location" for all nodes
    And I set the following inputs properties
      | registry_host | {{registry_host}} |
    And I deploy it
    And I should receive a RestResponse with no error
    And The application's deployment must succeed after 15 minutes
    And I upload the local archive "topologies/updatable-topology-ST.yml"
    And I create an application version for application "updatableapp" with version "0.2.0-SNAPSHOT", description "A new version without relationship.", topology template id "UpdatableTopologyST:0.1.0-SNAPSHOT" and previous version id "null"
    And I should receive a RestResponse with no error
    And I update the application environment named "Environment" with values
      | currentVersionId | 0.2.0-SNAPSHOT |
    And I Set a unique location policy to "Mount doom orchestrator"/"Thark location" for all nodes
    And I set the following inputs properties
      | registry_host | {{registry_host}} |
    And I update the deployment
    And The deployment update should succeed after 15 minutes

    Given I call the URL which is defined in registered string "registry_url" with path "/get_instance_id.php?node=GenericHostS&idx=0" and fetch the response and store it in the context as "GenericHostS_0_id"
    And I call the URL which is defined in registered string "registry_url" with path "/get_instance_id.php?node=GenericS&idx=0" and fetch the response and store it in the context as "GenericS_0_id"
    And I call the URL which is defined in registered string "registry_url" with path "/get_instance_id.php?node=GenericT&idx=0" and fetch the response and store it in the context as "GenericT_0_id"

    # the remove_target has been called on the source
    When I call the URL which is defined in registered string "registry_url" with path "/get_instance_log.php?node=GenericS&idx=0" and fetch the response and store it in the context as "GenericS_0_logs"
    Then the registered string "GenericS_0_logs" lines should match the following regex sequence
      | #\d+ - add_target/GenericT/0/${GenericT_0_id} |
      | #\d+ - remove_target/GenericT/0/${GenericT_0_id} |

    # the remove_source has been called on the target
    When I call the URL which is defined in registered string "registry_url" with path "/get_instance_log.php?node=GenericT&idx=0" and fetch the response and store it in the context as "GenericT_0_logs"
    Then the registered string "GenericT_0_logs" lines should match the following regex sequence
      | #\d+ - add_source/GenericS/0/${GenericS_0_id} |
      | #\d+ - remove_source/GenericS/0/${GenericS_0_id} |

  Scenario: Add the relationship
    Given I am authenticated with "ADMIN" role
    And I upload the local archive "topologies/updatable-topology-ST.yml"
    And I create a new application with name "updatableapp" and description "First version of my application with source and target" based on the template with name "UpdatableTopologyST"
    And I Set a unique location policy to "Mount doom orchestrator"/"Thark location" for all nodes
    And I set the following inputs properties
      | registry_host | {{registry_host}} |
    And I deploy it
    And I should receive a RestResponse with no error
    And The application's deployment must succeed after 15 minutes
    And I upload the local archive "topologies/updatable-topology-STR.yml"
    And I create an application version for application "updatableapp" with version "0.2.0-SNAPSHOT", description "A new version with added relationship.", topology template id "UpdatableTopologySTR:0.1.0-SNAPSHOT" and previous version id "null"
    And I should receive a RestResponse with no error
    And I update the application environment named "Environment" with values
      | currentVersionId | 0.2.0-SNAPSHOT |
    And I Set a unique location policy to "Mount doom orchestrator"/"Thark location" for all nodes
    And I set the following inputs properties
      | registry_host | {{registry_host}} |
    And I update the deployment
    And The deployment update should succeed after 15 minutes

    Given I call the URL which is defined in registered string "registry_url" with path "/get_instance_id.php?node=GenericHostS&idx=0" and fetch the response and store it in the context as "GenericHostS_0_id"
    And I call the URL which is defined in registered string "registry_url" with path "/get_instance_id.php?node=GenericS&idx=0" and fetch the response and store it in the context as "GenericS_0_id"
    And I call the URL which is defined in registered string "registry_url" with path "/get_instance_id.php?node=GenericT&idx=0" and fetch the response and store it in the context as "GenericT_0_id"

    # the add_target has been called on the source
    When I call the URL which is defined in registered string "registry_url" with path "/get_instance_log.php?node=GenericS&idx=0" and fetch the response and store it in the context as "GenericS_0_logs"
    Then the registered string "GenericS_0_logs" lines should match the following regex sequence
      | #\d+ - start |
      | #\d+ - add_target/GenericT/0/${GenericT_0_id} |

    # the add_source has been called on the target
    When I call the URL which is defined in registered string "registry_url" with path "/get_instance_log.php?node=GenericT&idx=0" and fetch the response and store it in the context as "GenericT_0_logs"
    Then the registered string "GenericT_0_logs" lines should match the following regex sequence
      | #\d+ - start |
      | #\d+ - add_source/GenericS/0/${GenericS_0_id} |


