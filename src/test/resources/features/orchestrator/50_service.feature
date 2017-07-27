Feature: Service offers capability

  Scenario:
    Given I am authenticated with "ADMIN" role
    And I create a new application with name "mongo-service" and description "Test alien4cloud service: Use case mongodb as a service for node cellar(service offers capability)" based on the template with name "org.alien4cloud.nodes.HostedMongo"
    And I Set a unique location policy to "cfy"/"aws" for all nodes
    And I substitute on the current application the node "MongoDbHost" with the location resource "cfy"/"aws"/"Nano_Ubuntu"
    And I create a new application with name "node-cellar" and description "Test alien4cloud service: Use case mongodb as a service for node cellar (service offers capability)" based on the template with name "nodecellar-mongo-service-topology"
    And I Set a unique location policy to "cfy"/"aws" for all nodes
    And I substitute on the current application the node "NodejsHost" with the location resource "cfy"/"aws"/"Nano_Ubuntu"
    And I deploy the application "mongo-service" on the location "cfy"/"aws"
    And I successfully create a service with name "mongo-service", from the deployed application "mongo-service", environment "Environment"
    When I deploy the application "node-cellar" on the location "cfy"/"aws"
    Then I should receive a RestResponse with no error
    And The URL which is defined in attribute "nodecellar_url" of the node "Nodecellar" should work