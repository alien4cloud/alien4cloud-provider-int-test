package org.alien4cloud.it.run;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
 * This test requires some environment variables to be configured prior launch:
 * ALIEN_URL
 *
 * CFY_MANAGER_URL
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
        "classpath:features/postdeployment/62_auto_heal.feature", //Test auto heal  --> KO
        "classpath:features/zartifact/24_compute_ansible.feature", // Test linux compute with an ansible artifact
        //
}, format = { "pretty", "html:target/cucumber/cloudify3/amazon", "json:target/cucumber/cloudify3/cucumber-amazon.json" }, glue = { "alien4cloud.it",
        "org.alien4cloud.it.aws" })
public class RunCloudify4AmazonIT {
}