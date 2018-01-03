package org.alien4cloud.it.run;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
 * Before launching the test, please take a look at README.txt for configuring the environment variables.
 */
@RunWith(Cucumber.class)
@CucumberOptions(features = {
        //
        "classpath:features/cloudify4/00_aws_setup.feature", // Configure cfy orchestrator and aws location
        "classpath:features/common/00__setup.feature", // Import test archives
        "classpath:features/location/01_compute.feature", // Test linux compute support
        "classpath:features/location/02_compute_deletable_block.feature", // Test linux compute and deletable block storage support
        "classpath:features/location/03_compute_block.feature", // Test linux compute and block storage support
        "classpath:features/location/04_compute_network.feature", // Test linux compute with an Apache and a public IP
        // "classpath:features/location/05_compute_exist_network.feature" // Not supported,
        "classpath:features/orchestrator/20_lifecycle.feature", // Check that orchestrator execute correct lifecycle
        "classpath:features/orchestrator/20_lifecycle_2_0_0.feature", // Check that orchestrator execute correct lifecycle
        "classpath:features/orchestrator/50_service.feature", // Check that service is ok
        "classpath:features/postdeployment/60_predifinedoperation.feature", "classpath:features/postdeployment/62_auto_heal.feature", // Test auto heal --> KO
        "classpath:features/postdeployment/63_scaling.feature", // Test scale / unscale and loadbalancer
        "classpath:features/zartifact/24_compute_ansible.feature", // Test linux compute with an ansible artifact
        "classpath:features/vault_provider" // Vault provider test

}, format = { "pretty", "html:target/cucumber/cloudify3/amazon", "json:target/cucumber/cloudify3/cucumber-amazon.json" }, glue = { "alien4cloud.it",
        "org.alien4cloud.it.aws" })
public class RunCloudify4AmazonIT {
}