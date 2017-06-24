package org.alien4cloud.it.aws;

import cucumber.api.java.en.Then;
import org.alien4cloud.it.common.Utils;
import org.junit.Assert;

import alien4cloud.it.Context;
import alien4cloud.it.provider.util.RuntimePropertiesUtil;
import cucumber.api.java.en.And;

/**
 * Implementation of location specific tests for aws.
 */
public class AwsStepDefinitions {
    @And("^I should have a volume for node \"([^\"]*)\"$")
    public void checkVolumeExistForNode(String nodeName) throws Throwable {
        String externalId = RuntimePropertiesUtil.getProperty(nodeName, "aws_resource_id");
        Context.getInstance().setCurrentExternalId(externalId);
        Assert.assertNotNull(Context.getInstance().getAwsClient().getVolume(externalId));
    }

    @Then("^I should have a persisted volume for node \"([^\"]*)\" in application \"([^\"]*)\"$")
    public void checkPersistedVolumeExistForNode(String nodeName, String applicationName) throws Throwable {
        String externalId = Utils.getTopologyProperty("volume_id", nodeName, applicationName);
        Assert.assertNotNull(externalId);
        Assert.assertNotNull(Context.getInstance().getAwsClient().getVolume(externalId));
    }

    @And("^I should not have a volume for node \"([^\"]*)\" in application \"([^\"]*)\"$")
    public void checkVolumeDoNotExistForNode(String nodeName, String applicationName) throws Throwable {
        String externalId = Utils.getTopologyProperty("volume_id", nodeName, applicationName);
        Assert.assertNull(externalId);
    }

    @And("^Volume id should be persisted for node \"([^\"]*)\" in application \"([^\"]*)\"$")
    public void checkVolumeIdPersisted(String nodeName, String applicationName) throws Throwable {
        String externalId = Utils.getTopologyProperty("volume_id", nodeName, applicationName);
        Assert.assertNotNull(externalId);
    }

    @And("^No volume id should be persisted for node \"([^\"]*)\" in application \"([^\"]*)\"$")
    public void checkVolumeIdNotPersisted(String nodeName, String applicationName) throws Throwable {
        String externalId = Utils.getTopologyProperty("volume_id", nodeName, applicationName);
        Assert.assertNull(externalId);
    }

    @And("^I delete the volume for node \"([^\"]*)\" in application \"([^\"]*)\"$")
    public void deleteVolume(String nodeName, String applicationName) throws Throwable {
        String externalId = Utils.getTopologyProperty("volume_id", nodeName, applicationName);
        Context.getInstance().getAwsClient().deleteVolume(externalId);
    }
}