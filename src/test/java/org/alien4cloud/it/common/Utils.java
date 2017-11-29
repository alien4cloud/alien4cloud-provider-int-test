package org.alien4cloud.it.common;

import alien4cloud.deployment.DeploymentTopologyDTO;
import alien4cloud.it.Context;
import alien4cloud.rest.model.RestResponse;
import alien4cloud.rest.utils.JsonUtil;
import alien4cloud.utils.PropertyUtil;
import org.junit.Assert;

import java.io.IOException;

/**
 * Utility class used in provider tests context.
 */
public class Utils {
    public static String getTopologyProperty(String propertyName, String nodeName, String appName) throws IOException {
        String topologyResponseText = Context.getRestClientInstance().get("/rest/v1/applications/" + Context.getInstance().getApplicationId(appName)
                + "/environments/" + Context.getInstance().getDefaultApplicationEnvironmentId(appName) + "/deployment-topology");
        RestResponse<DeploymentTopologyDTO> topologyResponse = JsonUtil.read(topologyResponseText, DeploymentTopologyDTO.class, Context.getJsonMapper());
        return PropertyUtil.getScalarValue(topologyResponse.getData().getTopology().getNodeTemplates().get(nodeName).getProperties().get(propertyName));
    }

    public static String getVolumeId(String propertyName, String nodeName, String appName) throws IOException {
        String volumeId = getTopologyProperty(propertyName, nodeName, appName);
        Assert.assertNotNull(volumeId);
        int indexOfEndRegion = volumeId.indexOf('/');
        if (indexOfEndRegion > 0) {
            volumeId = volumeId.substring(indexOfEndRegion + 1);
        }
        return volumeId;
    }
}
