package dev.samloh.guacamole_extensions.anyhow_aws.model;

import org.apache.guacamole.protocol.GuacamoleConfiguration;

import java.util.Map;

public class Configuration {

    private String configurationId;
    private String protocol;
    private Map<String, String> parameters;


    public String getConfigurationId() {
        return configurationId;
    }

    public void setConfigurationId(String configurationId) {
        this.configurationId = configurationId;
    }

    public String getProtocol() {
        return protocol;
    }

    public void setProtocol(String protocol) {
        this.protocol = protocol;
    }

    public Map<String, String> getParameters() {
        return parameters;
    }

    public void setParameters(Map<String, String> parameters) {
        this.parameters = parameters;
    }

    public GuacamoleConfiguration asGuacamoleConfiguration() {
        GuacamoleConfiguration guacamoleConfiguration = new GuacamoleConfiguration();
        guacamoleConfiguration.setConnectionID(this.configurationId);
        guacamoleConfiguration.setParameters(this.parameters);
        guacamoleConfiguration.setProtocol(this.protocol);
        return guacamoleConfiguration;
    }

    @Override
    public String toString() {
        StringBuilder parametersStringBuilder = new StringBuilder();
        parameters.forEach((parameter, value) -> parametersStringBuilder.append(String.format("%s=%s,", parameter, value)));
        return "Configuration{" +
                "connectionId='" + configurationId + '\'' +
                ", protocol='" + protocol + '\'' +
                ", parameters=" + parametersStringBuilder.toString() +
                '}';
    }
}
