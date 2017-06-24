Feature: Deletable Block Storage

  @location @aws
  Scenario: Deploy compute node with block storage
    Given I am authenticated with "ADMIN" role
    And I create a new application with name "computeblock" and description "Persistent block storage support test" based on the template with name "org.alien4cloud.tests.topologies.computeblock"
    And I Set a unique location policy to "cfy"/"aws" for all nodes
    And I substitute on the current application the node "BlockStorage" with the location resource "cfy"/"aws"/"SmallBlock"
    When I deploy it
    Then I should receive a RestResponse with no error
    # This is a timeout but this will end ASAP.
    And The application's deployment must succeed after 15 minutes
    # check that the volume exist on the target location
    And I should have a volume for node "BlockStorage"
    And Volume id should be persisted for node "BlockStorage" in application "computeblock"

  @location @aws
  Scenario: Un deploy compute node with block storage
    Given I am authenticated with "ADMIN" role
    When I undeploy it
    Then I should receive a RestResponse with no error
    # check that the volume exist on the target location
    And I should have a persisted volume for node "BlockStorage" in application "computeblock"
    And Volume id should be persisted for node "BlockStorage" in application "computeblock"
    And I delete the volume for node "BlockStorage" in application "computeblock"
