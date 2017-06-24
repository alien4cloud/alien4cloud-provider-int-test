Feature: Deletable Block Storage

  @location @aws
  Scenario: Deploy compute node with deletable block storage
    Given I am authenticated with "ADMIN" role
    And I create a new application with name "computedeletableblock" and description "Deletable block storage support test" based on the template with name "org.alien4cloud.tests.topologies.computeblock"
    And I Set a unique location policy to "cfy"/"aws" for all nodes
    And I substitute on the current application the node "BlockStorage" with the location resource "cfy"/"aws"/"SmallDeletableBlock"
    When I deploy it
    Then I should receive a RestResponse with no error
    # This is a timeout but this will end ASAP.
    And The application's deployment must succeed after 15 minutes
    # check that the volume exist on the target location
    And I should have a volume for node "BlockStorage"
    And No volume id should be persisted for node "BlockStorage" in application "computedeletableblock"

  @location @aws
  Scenario: Un deploy compute node with deletable block storage
    Given I am authenticated with "ADMIN" role
    When I undeploy it
    Then I should receive a RestResponse with no error
    # check that the volume has been deleted on the target location
    And I should not have a volume for node "BlockStorage" in application "computedeletableblock"
    And No volume id should be persisted for node "BlockStorage" in application "computedeletableblock"
