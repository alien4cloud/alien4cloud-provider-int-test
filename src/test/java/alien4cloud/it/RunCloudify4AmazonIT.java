package alien4cloud.it;

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
        "classpath:features/cloudify4/aws_setup.feature", // Configure cfy orchestrator and aws location
        "classpath:features/common/setup.feature", // Import test archives
        "classpath:features/common/compute_software.feature" // Test linux compute support
        //
}, format = { "pretty", "html:target/cucumber/cloudify3/amazon", "json:target/cucumber/cloudify3/cucumber-amazon.json" })
public class RunCloudify4AmazonIT {
}