Feature: Compute Node

  Scenario: Create application from the template
    Given I am authenticated with "ADMIN" role
    And I create a new application with name "compute" and description "Compute node support test" based on the template with name "org.alien4cloud.tests.topologies.computedeletableblock"
    And I Set a unique location policy to "cfy"/"aws" for all nodes
    # Should match node to SmallDeletableBlock ?

  Scenario: Deploy compute node with deletable block storage
    Given I am authenticated with "ADMIN" role
    When I deploy it
    Then I should receive a RestResponse with no error
    # This is a timeout but this will end ASAP.
    And The application's deployment must succeed after 15 minutes
    And The URL which is defined in attribute "apache_url" of the node "Apache" should work and the html should contain "Index of /"
    Then I should have a volume on AWS with id defined in runtime property "aws_resource_id" of the node "BlockStorage"

  Scenario: Un deploy compute node with deletable block storage
    Given I am authenticated with "ADMIN" role
    When I undeploy it
    Then I should receive a RestResponse with no error
    Then I should not have a volume on AWS with id defined in runtime property "aws_resource_id" of the node "BlockStorage"
