Feature: Configure cloudify 4 orchestrator

  Scenario: Setup cloudify orchestrator
    Given I am authenticated with "ADMIN" role
    # Create orchestrator
    And I create an orchestrator named "cfy" and plugin name "alien-cloudify-4-orchestrator-premium" and bean name "cloudify-orchestrator"
    And I get configuration for orchestrator "cfy"
    And I update configuration for orchestrator with name "cfy"
      | url                    | CFY_MANAGER_URL             |
      | userName               | CFY_MANAGER_USER            |
      | password               | CFY_MANAGER_PASSWORD        |
      | logQueuePort           | CFY_MANAGER_LOG_PORT        |
      | disableSSLVerification | true                        |
      | postDeploymentRestURL  | AWS_POST_DEPLOYMENT_APP_URL |
    And I enable the orchestrator "cfy"
    # Create location
    And I create a location named "aws" and infrastructure type "amazon" to the orchestrator "cfy"
    # Configure nano flavor resource
    And I create a resource of type "alien.cloudify.aws.nodes.InstanceType" named "Nano" related to the location "cfy"/"aws"
    And I update the property "id" to "t2.nano" for the resource named "Nano" related to the location "cfy"/"aws"
    # Configure medium flavor resource for test on scaling (jdk + tomcat + war)
    And I create a resource of type "alien.cloudify.aws.nodes.InstanceType" named "Medium" related to the location "cfy"/"aws"
    And I update the property "id" to "m3.medium" for the resource named "Medium" related to the location "cfy"/"aws"
    # Configure large flavor resource (for windows test)
    # And I create a resource of type "alien.cloudify.aws.nodes.InstanceType" named "Large" related to the location "cfy"/"aws"
    # And I update the property "id" to "m3.large" for the resource named "Large" related to the location "cfy"/"aws"
    # Create ubuntu image resource
    And I create a resource of type "alien.cloudify.aws.nodes.Image" named "Ubuntu" related to the location "cfy"/"aws"
    And I update the property "id" to "ami-47a23a30" for the resource named "Ubuntu" related to the location "cfy"/"aws"
    And I update the capability "os" property "architecture" to "x86_64" for the resource named "Ubuntu" related to the location "cfy"/"aws"
    And I update the capability "os" property "type" to "linux" for the resource named "Ubuntu" related to the location "cfy"/"aws"
    And I update the capability "os" property "distribution" to "ubuntu" for the resource named "Ubuntu" related to the location "cfy"/"aws"
    And I update the capability "os" property "version" to "14" for the resource named "Ubuntu" related to the location "cfy"/"aws"
    # Create windows image resource
    And I create a resource of type "alien.cloudify.aws.nodes.Image" named "Windows" related to the location "cfy"/"aws"
    And I update the property "id" to "ami-59809e3f" for the resource named "Windows" related to the location "cfy"/"aws"
    And I update the capability "os" property "architecture" to "x86_64" for the resource named "Windows" related to the location "cfy"/"aws"
    And I update the capability "os" property "type" to "windows" for the resource named "Windows" related to the location "cfy"/"aws"
    # Generate computes
    And I autogenerate the on-demand resources for the location "cfy"/"aws"
    # Configure windows instance
    And I update the property "key_pair" to the environment variable "AWS_KEY_NAME" for the resource named "Nano_Windows" related to the location "cfy"/"aws"
    And I update the property "user" to "cloudify" for the resource named "Nano_Windows" related to the location "cfy"/"aws"
    And I update the property "password" to "Cl@ud1fy234!" for the resource named "Nano_Windows" related to the location "cfy"/"aws"
    # Configure security groups
    And I update the complex property "parameters" to """{"security_group_ids": ["sg-81001bf8","sg-cffd98b6"]}""" for the resource named "Nano_Ubuntu" related to the location "cfy"/"aws"
    And I update the complex property "parameters" to """{"security_group_ids": ["sg-81001bf8","sg-cffd98b6"]}""" for the resource named "Medium_Ubuntu" related to the location "cfy"/"aws"
    And I update the complex property "parameters" to """{"security_group_ids": ["sg-81001bf8","sg-cffd98b6"]}""" for the resource named "Nano_Windows" related to the location "cfy"/"aws"
    # Configure agent client
    And I update the complex property "cloudify_agent" to """{"user": "ubuntu"}""" for the resource named "Nano_Ubuntu" related to the location "cfy"/"aws"
    And I update the complex property "cloudify_agent" to """{"user": "ubuntu"}""" for the resource named "Medium_Ubuntu" related to the location "cfy"/"aws"
    # Configure deletable block storage
    And I create a resource of type "alien.cloudify.aws.nodes.DeletableVolume" named "SmallDeletableBlock" related to the location "cfy"/"aws"
    And I update the property "size" to "1 gib" for the resource named "SmallDeletableBlock" related to the location "cfy"/"aws"
    And I update the property "device" to "/dev/sdf" for the resource named "SmallDeletableBlock" related to the location "cfy"/"aws"
    # Configure block storage
    And I create a resource of type "alien.cloudify.aws.nodes.Volume" named "SmallBlock" related to the location "cfy"/"aws"
    And I update the property "size" to "1 gib" for the resource named "SmallBlock" related to the location "cfy"/"aws"
    And I update the property "device" to "/dev/sdf" for the resource named "SmallBlock" related to the location "cfy"/"aws"
    # Add public network
    And I create a resource of type "alien.nodes.aws.PublicNetwork" named "Internet" related to the location "cfy"/"aws"
