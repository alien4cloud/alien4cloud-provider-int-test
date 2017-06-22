Feature: Compute Network

  @location @aws
  Scenario: Deploy compute node with network
    Given I am authenticated with "ADMIN" role
    And I create a new application with name "compute" and description "Compute node support test" based on the template with name "org.alien4cloud.tests.topologies.compute_network"
    And I Set a unique location policy to "cfy"/"aws" for all nodes
    When I deploy it
    Then I should receive a RestResponse with no error
    # This is a timeout but this will end ASAP.
    And The application's deployment must succeed after 15 minutes
    And The URL which is defined in attribute "load_balancer_url" of the node "ApacheLoadBalancer" should work and the html should contain "Welcome to Fastconnect !"