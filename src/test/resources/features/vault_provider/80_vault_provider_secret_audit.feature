Feature: Deploy an application with Vault Secret Provider

  @aws
  Scenario: Setup the secret provider with ldap and deploy "secret-management-test" which will resolve the secrets from vault via HTTPS
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
    And I create a new application with name "SecretManagementDeploy" and description "Secret management test with vault and ldap" based on the template with name "topology-secret-management-test"
    And I Set a unique location policy to "cfy"/"aws" for all nodes

    # Deploy the application
    When I deploy it with the following credentials defined by the secret provider plugin "alien-vault-plugin"
      | user     | guobao |
      | password | alien  |
    # Check the audited log
    Then I should have a latest audit trace with a query defined below and whose secret "secretProviderCredentials" defined in requestBody should be hidden:
      | category | ApplicationDeployment |
      | action   | deploy                |

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

    When I undeploy it
    Then I should receive a RestResponse with no error