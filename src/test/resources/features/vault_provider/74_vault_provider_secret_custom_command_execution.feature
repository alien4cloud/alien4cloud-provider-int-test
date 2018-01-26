Feature: Execute the custom command with Vault Secret Provider

  @aws
  Scenario: Deploy an application and then execute the custom command
    Given I am authenticated with "ADMIN" role
    # Use the vault plugin as the secret provider plugin
    And I should have a secret provider named "alien-vault-plugin" in the list of secret providers
    And I use "alien-vault-plugin" as the secret provider and I update the configuration of secret provider related to the location "aws" of the orchestrator "cfy"
      | url                  | VAULT_URL        |
      | authenticationMethod | ldap             |
      | certificate          | CERTIFICATE_PATH |

    # Archives
    And I successfully upload the local archive "csars/secret-management-test"
    And I successfully upload the local archive "csars/topology-secret-management-test"

    # Create the application
    And I create a new application with name "SecretManagementCustomCommandExecution" and description "Secret management test with vault and ldap" based on the template with name "topology-secret-management-test"
    And I Set a unique location policy to "cfy"/"aws" for all nodes

    # Deploy the application
    When I deploy it with the following credentials defined by the secret provider plugin "alien-vault-plugin"
      | user     | guobao |
      | password | alien  |
    Then I should receive a RestResponse with no error
    And The application's deployment must succeed after 15 minutes
    And The URL which is defined in attribute "apache_url" of the node "Apache" should work
    And I store the attribute "apache_url" of the node "Apache" as registered string "apache_url"
    When I call the URL which is defined in registered string "apache_url" with path "/html/vault/test/secret.txt" and fetch the response and store it in the context as "secretTxt"
    Then the registered string "secretTxt" lines should match the following regex sequence
      | ^Secret : guigui$ |
    When I call the URL which is defined in registered string "apache_url" with path "/html/vault/test/secret_property.txt" and fetch the response and store it in the context as "secretPropertyTxt"
    Then the registered string "secretPropertyTxt" lines should match the following regex sequence
      | ^Secret property : guigui$ |

    # Execute custom command operation
    When I trigger on the node template "SecretComponent" the custom command "custom_command" of the interface "custom" for application "SecretManagementCustomCommandExecution" using the secret provider "alien-vault-plugin" and the secret credentials "user: guobao, password: alien" with parameters:
      # Should use the json format if the property value is a function
      | complex_input | {"function": "get_secret", "parameters": ["secret/mysql_password"]} |
      | secret_input  | {"function": "get_secret", "parameters": ["secret/mysql_password"]} |
    Then I should receive a RestResponse with no error
    When I call the URL which is defined in registered string "apache_url" with path "/html/vault/test/complex_input.txt" and fetch the response and store it in the context as "complexInputTxt"
    Then the registered string "complexInputTxt" lines should match the following regex sequence
      | ^Complex input : guigui$ |
    When I call the URL which is defined in registered string "apache_url" with path "/html/vault/test/secret_input.txt" and fetch the response and store it in the context as "secretInputTxt"
    Then the registered string "secretInputTxt" lines should match the following regex sequence
      | ^Secret input : guigui$ |

    When I undeploy it
    Then I should receive a RestResponse with no error