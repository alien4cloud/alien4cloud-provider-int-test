Feature: Scaling

  @location @aws
  Scenario: Deploy an apache with load balancer and scale/unscale it
    Given I am authenticated with "ADMIN" role
    And I create a new application with name "scaling" and description "Scale an apache with load balancer" based on the template with name "org.alien4cloud.tests.topologies.scaling"
    And I Set a unique location policy to "cfy"/"aws" for all nodes
    When I deploy it
    Then I should receive a RestResponse with no error
    And The application's deployment must succeed after 15 minutes
    And The URL which is defined in attribute "load_balancer_url" of the node "ApacheLoadBalancer" should work and the html should contain "Welcome to Fastconnect !"
    # Scale up/down part
    When I scale up the node "WebServer" by adding 1 instance(s)
    Then I should receive a RestResponse with no error
    And The node "War" should contain 2 instance(s) after at maximum 15 minutes
    And The URL which is defined in attribute "load_balancer_url" of the node "ApacheLoadBalancer" should work and the html should contain "Welcome to Fastconnect !"
    When I scale down the node "WebServer" by removing 1 instance(s)
    Then I should receive a RestResponse with no error
    And The node "War" should contain 1 instance(s) after at maximum 15 minutes
    # Test passed, we un-deploy the app
    Then I undeploy it