Feature: Setup the secret provider in aws location

  @aws
  Scenario: Setup the secret provider with ldap and deploy an application of secret-management-test which will fetch a secret from vault with HTTPS
    Given I am authenticated with "ADMIN" role
    # Upload the plugin
#    And I upload the vault plugin
    # Use the vault plugin as the secret provider plugin
    And I should have a secret provider named "alien-vault-plugin" in the list of secret providers
    And I use "alien-vault-plugin" as the secret provider and I update the configuration of secret provider related to the location "aws" of the orchestrator "cfy"
    # VAULT_URL=https://34.251.3.178:8200
      | url                  | VAULT_URL                   |
      | authenticationMethod | ldap                        |

    # Archives
    And I successfully upload the local archive "csars/secret-managment-test"
    And I successfully upload the local archive "csars/topology-secret-managment-test"

    # Create the application
    And I create a new application with name "Secret-Test" and description "Secret management test with vault and ldap" based on the template with name "topology-secret-management-test"
    And I Set a unique location policy to "cfy"/"aws" for all nodes

    # Fill in the ldap username and password
    When I deploy it with the following credentials defined by the secret provider plugin "alien-vault-plugin"
      | user     | guobao |
      | password | alien  |

    Then I should receive a RestResponse with no error
    And The application's deployment must succeed after 15 minutes
    # todo: parse the logs application to see if secret resolved