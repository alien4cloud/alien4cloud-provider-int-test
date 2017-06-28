Feature: Load test archives

  # This loads archives from git into alien4cloud
  Scenario: Load required archives from git
    Given I am authenticated with "ADMIN" role
    And I add a GIT repository with url "https://github.com/alien4cloud/samples.git" usr "" pwd "" stored "false" and locations
      | branchId | subPath                             |
      | master   | org/alien4cloud/www/apache/pub      |
      | master   | org/alien4cloud/www/apache/linux_sh |
      | master   | apache                              |
      | master   | php                                 |
      | master   | demo-lifecycle                      |
    And I get the GIT repo with url "https://github.com/alien4cloud/samples.git"
    And I import the GIT repository
    # public_a4c_build is a user that can just checkout the alien4cloud-it-archives project. This project is currently hosted on our private gitlab but will migrate later on github. It is however not a private project.
    # the user cannot do or access anything else on gitlab.
    And I add a GIT repository with url "https://fastconnect.org/a4c-gitlab/alien4cloud-experiments/alien4cloud-it-archives.git" usr "public_a4c_build" pwd "a4c_public_build" stored "false" and locations
      | branchId | subPath |
      | master   |         |
    And I get the GIT repo with url "https://fastconnect.org/a4c-gitlab/alien4cloud-experiments/alien4cloud-it-archives.git"
    And I import the GIT repository
