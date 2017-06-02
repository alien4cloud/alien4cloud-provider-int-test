package alien4cloud.it;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

@RunWith(Cucumber.class)
@CucumberOptions(features = {
        "classpath:features/cloudify3/amazon/"
        // "classpath:features/cloudify3/amazon/apache_load_balancer_tomcat.feature"
        // "classpath:features/cloudify3/amazon/common_location_validation.feature"
        // "classpath:features/cloudify3/amazon/deployment_update_failure.feature"
        // "classpath:features/cloudify3/amazon/windows.feature"
        // "classpath:features/cloudify3/amazon/auto_heal.feature"
        // "classpath:features/cloudify3/amazon/deletable_block_storage.feature"
        // "classpath:features/cloudify3/amazon/deployment_update.feature"
        // "classpath:features/cloudify3/amazon/wordpress.feature"
        // "classpath:features/cloudify3/amazon/block_storage.feature"
        // "classpath:features/cloudify3/amazon/deployment_artifacts.feature"
        // "classpath:features/cloudify3/amazon/lifecycle.feature"
}, format = { "pretty", "html:target/cucumber/cloudify3/amazon",
        "json:target/cucumber/cloudify3/cucumber-amazon.json" })
public class RunCloudify3AmazonIT {
}
