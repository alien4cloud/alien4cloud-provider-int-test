package org.alien4cloud.it.aws;

import gherkin.lexer.No;
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
        String externalId = RuntimePropertiesUtil.getProperty(nodeName, "");
        Context.getInstance().setCurrentExternalId(externalId);
        Assert.assertNotNull(Context.getInstance().getAwsClient().getVolume(externalId));
    }

    @And("^I should not have a volume for node \"([^\"]*)\"$")
    public void checkVolumeDoNotExistForNode(String nodeName) throws Throwable {
        String externalId = RuntimePropertiesUtil.getProperty(nodeName, "");
        Context.getInstance().setCurrentExternalId(externalId);
        Assert.assertNull(Context.getInstance().getAwsClient().getVolume(externalId));
    }

    @And("^No volume id should be persisted for node \"([^\"]*)\"$")
    public void checkVolumeIdNotPersisted(String nodeName) throws Throwable {
        // String externalId = RuntimePropertiesUtil.getProperty(nodeName, "");
        // Context.getInstance().setCurrentExternalId(externalId);
        // Assert.assertNotNull(Context.getInstance().getAwsClient().getVolume(externalId));
    }
}