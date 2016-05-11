package alien4cloud.it;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

@RunWith(Cucumber.class)
@CucumberOptions(features = { "classpath:features/cloudify3/vsphere/" }, format = { "pretty" })
public class RunCloudify3VSphereIT {
}
