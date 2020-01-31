package dev.samloh.guacamole_extensions.anyhow_aws.model;

import org.apache.guacamole.protocol.GuacamoleConfiguration;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Configurations {
    private List<Configuration> configurations;

    public List<Configuration> getConfigurations() {
        return configurations;
    }

    public void setConfigurations(List<Configuration> configurations) {
        this.configurations = configurations;
    }

    public Map<String, GuacamoleConfiguration> asGuacamoleConfigurations() {
        Map<String, GuacamoleConfiguration> guacamoleConfigurations = new HashMap<>();
        configurations.forEach((configuration) -> {
            GuacamoleConfiguration guacamoleConfiguration = new GuacamoleConfiguration();
            String connectionId = configuration.getConfigurationId();
            String protocol = configuration.getProtocol();
            Map<String, String> parameters = configuration.getParameters();
            guacamoleConfiguration.setProtocol(protocol);
            guacamoleConfiguration.setParameters(parameters);
            guacamoleConfigurations.put(connectionId, guacamoleConfiguration);
        });
        return guacamoleConfigurations;
    }

    @Override
    public String toString() {
        return "Configurations{" +
                "configurations=" + configurations +
                '}';
    }
}
