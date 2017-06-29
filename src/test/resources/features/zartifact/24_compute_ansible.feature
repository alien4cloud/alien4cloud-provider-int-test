Feature: Artifact ansible

  Scenario: Create an apache through an ansible recipe

  @location @aws
  Scenario: Deploy apache through an ansible recipe
    Given I am authenticated with "ADMIN" role
    And I create a new application with name "compute_ansible" and description "Compute with an ansible apache" based on the template with name "org.alien4cloud.tests.topologies.compute_ansible"
    And I Set a unique location policy to "cfy"/"aws" for all nodes
    When I deploy it
    Then I should receive a RestResponse with no error
    # This is a timeout but this will end ASAP.
    And The application's deployment must succeed after 15 minutes
    And The URL which is defined in attribute "apache_url" of the node "AnsibleApache" should work and the html should contain "It works!"
    # Test passed, we un-deploy the app
    Then I undeploy it