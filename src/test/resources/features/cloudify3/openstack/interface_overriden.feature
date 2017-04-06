Feature: Interface overriding with cloudify 3
  # Tested features with this scenario:
  #   - Ability to override node interface operation in topology template
  #   - Ability to override relationship interface operation in topology template
  Scenario: Interface overriding with cloudify 3
    Given I am authenticated with "ADMIN" role

    # Archives
    And I checkout the git archive from url "https://github.com/alien4cloud/tosca-normative-types.git" branch "1.2.0"
    And I upload the git archive "tosca-normative-types"
    And I upload the local archive "csars/topology-override-interface"

    # Cloudify 3
    And I upload a plugin from maven artifact "alien4cloud:alien4cloud-cloudify4-provider"
#    And I upload a plugin from "../alien4cloud-cloudify4-provider"

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

    And I create a new application with name "TemplateOverrideInterfaceApp" and description "" based on the template with name "TemplateOverrideInterface"
    And I Set a unique location policy to "Mount doom orchestrator"/"Thark location" for all nodes

    When I deploy it
    Then I should receive a RestResponse with no error
    And The application's deployment must succeed after 15 minutes
   Given I wait for 30 seconds before continuing the test    
     And I trigger on the node template "software1" the custom command "customTemplateOperation" of the interface "CustomTemplateInterface" for application "TemplateOverrideInterfaceApp"
     And I trigger on the node template "software1" the custom command "customTypeOperation" of the interface "CustomTypeInterface" for application "TemplateOverrideInterfaceApp"
     And I trigger on the node template "software2" the custom command "customTypeOperation" of the interface "CustomTypeInterface" for application "TemplateOverrideInterfaceApp"
    When I download the remote file "/tmp/topology-override-interface-software1.txt" from the node "compute" with the keypair "keys/openstack/alien.pem" and user "ubuntu"
    Then The downloaded file should have the same content as the local file "csars/topology-override-interface/expected/topology-override-interface-software1.txt"
    When I download the remote file "/tmp/topology-override-interface-software2.txt" from the node "compute" with the keypair "keys/openstack/alien.pem" and user "ubuntu"
    Then The downloaded file should have the same content as the local file "csars/topology-override-interface/expected/topology-override-interface-software2.txt"
