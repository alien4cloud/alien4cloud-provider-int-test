Feature: Update Topology Deployment

  Background:
    Given I am authenticated with "ADMIN" role

  Scenario: Add a target and the relationship
    # create tand deploy he registry

    Given I create a new application with name "updateAddTargetLyfecycleRegistry" and description "Lifecycle registry for add target and relationship test" based on the template with name "org.alien4cloud.tests.topologies.update.lifecycleregistry"
    And I Set a unique location policy to "cfy"/"aws" for all nodes
    And I substitute on the current application the node "ComputeRegistry" with the location resource "cfy"/"aws"/"Medium_Ubuntu"
    And I deploy it
    And I should receive a RestResponse with no error
    And The application's deployment must succeed after 15 minutes
    And The URL which is defined in attribute "url" of the node "Registry" should work
    And I store the attribute "url" of the node "Registry" as registered string "registry_url"
    And I store the attribute "host" of the node "Registry" as registered string "registry_host"

#    And I upload the local archive "topologies/updatable-topology-S.yml"
    And I create a new application with name "updateAddTarget" and description "Add a target and the relationship: First version of my application only with source" based on the template with name "org.alien4cloud.tests.topologies.update.updatableS"
    And I Set a unique location policy to "cfy"/"aws" for all nodes
    And I set the following inputs properties
      | registry_host | {{registry_host}} |
    And I substitute on the current application the node "ComputeS" with the location resource "cfy"/"aws"/"Nano_Ubuntu"
    And I deploy it
    And I should receive a RestResponse with no error
    And The application's deployment must succeed after 15 minutes

    And I create an application version for application "updateAddTarget" with version "0.2.0-SNAPSHOT", description "A new version with target and relationship.", topology template id "org.alien4cloud.tests.topologies.update.updatableSTR:0.1.0-SNAPSHOT" and previous version id "null"
    And I should receive a RestResponse with no error
    Given I update the topology version of the application environment named "Environment" to "0.2.0-SNAPSHOT" with inputs from environment "Environment"
    When I update the deployment
    Then The deployment update should succeed after 15 minutes

    Given I call the URL which is defined in registered string "registry_url" with path "/get_instance_id.php?node=GenericHostS&idx=0" and fetch the response and store it in the context as "GenericHostS_0_id"
    And I call the URL which is defined in registered string "registry_url" with path "/get_instance_id.php?node=GenericS&idx=0" and fetch the response and store it in the context as "GenericS_0_id"
    And I call the URL which is defined in registered string "registry_url" with path "/get_instance_id.php?node=GenericT&idx=0" and fetch the response and store it in the context as "GenericT_0_id"

    # the target lifecycle operations has been called
    When I call the URL which is defined in registered string "registry_url" with path "/get_instance_log.php?node=GenericT&idx=0" and fetch the response and store it in the context as "GenericT_0_logs"
    Then the registered string "GenericT_0_logs" lines should match the following regex sequence
      | #\d+ - create                                                    |
      | #\d+ - pre_configure_source/GenericHostS/0/${GenericHostS_0_id}  |
      | #\d+ - configure                                                 |
      | #\d+ - post_configure_source/GenericHostS/0/${GenericHostS_0_id} |
      | #\d+ - start                                                     |
      | #\d+ - add_target/GenericHostS/0/${GenericHostS_0_id}            |
    And the registered string "GenericT_0_logs" lines should match the following regex sequence
      | #\d+ - start                                  |
      | #\d+ - add_source/GenericS/0/${GenericS_0_id} |

    # ensure that the add_target has been called on the source of the relationship
    When I call the URL which is defined in registered string "registry_url" with path "/get_instance_log.php?node=GenericS&idx=0" and fetch the response and store it in the context as "GenericS_0_logs"
    Then the registered string "GenericS_0_logs" lines should match the following regex sequence
      | #\d+ - start                                  |
      | #\d+ - add_target/GenericT/0/${GenericT_0_id} |

    # ensure that the property of the source has actually been changed
    When I can catch the following groups in one line of the registered string "GenericT_0_logs" and store them as registered strings
      | #(\d+) - add_source/GenericS/0/GenericS_.+ |
      | GenericT_0_addSource_GenericS_opIdx        |
    And I expand the string "${registry_url}/get_env_log.php?idx=${GenericT_0_addSource_GenericS_opIdx}" and store it as "GenericT_0_addSource_GenericS_env_url" in the context
    And I call the URL which is defined in registered string "GenericT_0_addSource_GenericS_env_url" with path "" and fetch the response and store it in the context as "GenericT_0_addSource_GenericS_env"
    Then the following expanded regex should be found in the registered string "GenericT_0_addSource_GenericS_env"
      | ^SOURCE_PROPERTY=STR$ |

    #test successfull: undeploy all
    Then I undeploy it
    Then I undeploy application "updateAddTargetLyfecycleRegistry", environment "Environment"


  Scenario: Remove the relationship
        # create and deploy he registry
    Given I create a new application with name "updateRemoveRelationshipLyfecycleRegistry" and description "Lifecycle registry for remove relationship test" based on the template with name "org.alien4cloud.tests.topologies.update.lifecycleregistry"
    And I Set a unique location policy to "cfy"/"aws" for all nodes
    And I substitute on the current application the node "ComputeRegistry" with the location resource "cfy"/"aws"/"Medium_Ubuntu"
    And I deploy it
    And I should receive a RestResponse with no error
    And The application's deployment must succeed after 15 minutes
    And The URL which is defined in attribute "url" of the node "Registry" should work
    And I store the attribute "url" of the node "Registry" as registered string "registry_url"
    And I store the attribute "host" of the node "Registry" as registered string "registry_host"


    And I create a new application with name "updateRemoveRelationship" and description "Remove relationship: First version of my application with source, target and relationship" based on the template with name "org.alien4cloud.tests.topologies.update.updatableSTR"
    And I Set a unique location policy to "cfy"/"aws" for all nodes
    And I set the following inputs properties
      | registry_host | {{registry_host}} |
    And I substitute on the current application the node "ComputeS" with the location resource "cfy"/"aws"/"Nano_Ubuntu"
    And I deploy it
    And I should receive a RestResponse with no error
    And The application's deployment must succeed after 15 minutes

    And I create an application version for application "updateRemoveRelationship" with version "0.2.0-SNAPSHOT", description "A new version without relationship.", topology template id "org.alien4cloud.tests.topologies.update.updatableST:0.1.0-SNAPSHOT" and previous version id "null"
    And I should receive a RestResponse with no error
    Given I update the topology version of the application environment named "Environment" to "0.2.0-SNAPSHOT" with inputs from environment "Environment"
    And I update the deployment
    And The deployment update should succeed after 15 minutes

    Given I call the URL which is defined in registered string "registry_url" with path "/get_instance_id.php?node=GenericHostS&idx=0" and fetch the response and store it in the context as "GenericHostS_0_id"
    And I call the URL which is defined in registered string "registry_url" with path "/get_instance_id.php?node=GenericS&idx=0" and fetch the response and store it in the context as "GenericS_0_id"
    And I call the URL which is defined in registered string "registry_url" with path "/get_instance_id.php?node=GenericT&idx=0" and fetch the response and store it in the context as "GenericT_0_id"

# the remove_target has been called on the source
    When I call the URL which is defined in registered string "registry_url" with path "/get_instance_log.php?node=GenericS&idx=0" and fetch the response and store it in the context as "GenericS_0_logs"
    Then the registered string "GenericS_0_logs" lines should match the following regex sequence
      | #\d+ - add_target/GenericT/0/${GenericT_0_id}    |
      | #\d+ - remove_target/GenericT/0/${GenericT_0_id} |

# the remove_source has been called on the target
    When I call the URL which is defined in registered string "registry_url" with path "/get_instance_log.php?node=GenericT&idx=0" and fetch the response and store it in the context as "GenericT_0_logs"
    Then the registered string "GenericT_0_logs" lines should match the following regex sequence
      | #\d+ - add_source/GenericS/0/${GenericS_0_id}    |
      | #\d+ - remove_source/GenericS/0/${GenericS_0_id} |

# test successfull: undeploy all
    Then I undeploy it
    Then I undeploy application "updateRemoveRelationshipLyfecycleRegistry", environment "Environment"


  Scenario: Add the relationship

        # create and deploy he registry
    Given I create a new application with name "updateAddRelationshipLyfecycleRegistry" and description "Lifecycle registry for add relationship test" based on the template with name "org.alien4cloud.tests.topologies.update.lifecycleregistry"
    And I Set a unique location policy to "cfy"/"aws" for all nodes
    And I substitute on the current application the node "ComputeRegistry" with the location resource "cfy"/"aws"/"Medium_Ubuntu"
    And I deploy it
    And I should receive a RestResponse with no error
    And The application's deployment must succeed after 15 minutes
    And The URL which is defined in attribute "url" of the node "Registry" should work
    And I store the attribute "url" of the node "Registry" as registered string "registry_url"
    And I store the attribute "host" of the node "Registry" as registered string "registry_host"


    And I create a new application with name "updateAddRelationship" and description "Add relationship: First version of my application with source and target" based on the template with name "org.alien4cloud.tests.topologies.update.updatableST"
    And I Set a unique location policy to "cfy"/"aws" for all nodes
    And I set the following inputs properties
      | registry_host | {{registry_host}} |
    And I substitute on the current application the node "ComputeS" with the location resource "cfy"/"aws"/"Nano_Ubuntu"
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
      | #\d+ - start                                  |
      | #\d+ - add_target/GenericT/0/${GenericT_0_id} |

    # the add_source has been called on the target
    When I call the URL which is defined in registered string "registry_url" with path "/get_instance_log.php?node=GenericT&idx=0" and fetch the response and store it in the context as "GenericT_0_logs"
    Then the registered string "GenericT_0_logs" lines should match the following regex sequence
      | #\d+ - start                                  |
      | #\d+ - add_source/GenericS/0/${GenericS_0_id} |