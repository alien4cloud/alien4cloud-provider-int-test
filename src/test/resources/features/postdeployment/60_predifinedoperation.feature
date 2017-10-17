Feature: Pre-defined operation

  @location @aws
  Scenario: Deploy an war and launch a pre-defined operation
    Given I am authenticated with "ADMIN" role
    And I create a new application with name "predefinedoperation" and description "Deploy an apache and launch a pre-defined operation" based on the template with name "org.alien4cloud.tests.topologies.predifinedoperation"
    And I Set a unique location policy to "cfy"/"aws" for all nodes
    When I deploy it
    Then I should receive a RestResponse with no error
    And The application's deployment must succeed after 15 minutes
    And The URL which is defined in attribute "apache_url" of the node "Apache" should work and the html should contain "Index of /"
    When I trigger on the node template "Apache" the custom command "update_data" of the interface "custom" for application "predefinedoperation" with parameters:
      | DATA | test_success |
    And I should wait for 10 seconds before continuing the test
    And The URL which is defined in attribute "apache_url" of the node "Apache" should work and the html should contain "Index of /" and "test_success"
    # Test passed, we un-deploy the app
    Then I undeploy it