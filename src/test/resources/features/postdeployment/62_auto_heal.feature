Feature: Auto heal

  @location @aws
  Scenario: Deploy a compute, kill the instance from IASS, A4C should auto heal.
    Given I am authenticated with "ADMIN" role
    And I create a new application with name "auto-heal" and description "Compute for autoheal test" based on the template with name "org.alien4cloud.tests.topologies.autoheal"
    And I Set a unique location policy to "cfy"/"aws" for all nodes
    And I set the following orchestrator properties
      | monitoring_interval_inMinute | 1    |
      | auto_heal                    | true |
    When I deploy it
    Then I should receive a RestResponse with no error
    And The application's deployment must succeed after 10 minutes
    # autoheal test
    When I delete one instance of compute node "Compute"
    And I wait for 120 seconds before continuing the test
    Then The node "Compute" should contain 1 instance(s) not started
    And all nodes instances must be in "started" state after 10 minutes
    # Test passed, we un-deploy the app
    Then I undeploy it