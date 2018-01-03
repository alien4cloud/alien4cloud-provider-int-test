Feature: Deploy an application who bootstraps an EC2Instance with Vault Secret Provider

  @aws
  Scenario: Deploy a given application
    Given I am authenticated with "ADMIN" role
    # Use the vault plugin as the secret provider plugin
    And I should have a secret provider named "alien-vault-plugin" in the list of secret providers
    And I use "alien-vault-plugin" as the secret provider and I update the configuration of secret provider related to the location "aws" of the orchestrator "cfy"
      | url                  | VAULT_URL        |
      | authenticationMethod | ldap             |
      | certificate          | CERTIFICATE_PATH |

    # Archives
    And I successfully upload the local archive "csars/topology-ec2instance"

    # Create the application
    And I create a new application with name "SecretTestWithEC2Instance" and description "Secret management test with vault and ldap to deploy a simple ec2instance" based on the template with name "ec2instance-template"
    And I Set a unique location policy to "cfy"/"aws" for all nodes

    # Deploy the application
    When I deploy it with the following credentials defined by the secret provider plugin "alien-vault-plugin"
      | user     | guobao |
      | password | alien  |
    Then I should receive a RestResponse with no error
    And The application's deployment must succeed after 15 minutes

    When I undeploy it
    Then I should receive a RestResponse with no error
