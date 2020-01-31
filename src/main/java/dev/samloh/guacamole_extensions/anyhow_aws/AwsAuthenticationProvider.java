package dev.samloh.guacamole_extensions.anyhow_aws;

import dev.samloh.guacamole_extensions.anyhow_aws.model.Configurations;
import dev.samloh.guacamole_extensions.anyhow_aws.util.Ec2DescribeInstancesUtil;
import dev.samloh.guacamole_extensions.anyhow_aws.util.LambdaUtil;
import dev.samloh.guacamole_extensions.anyhow_aws.util.OverrideUtil;
import org.apache.commons.lang3.StringUtils;
import org.apache.guacamole.GuacamoleClientException;
import org.apache.guacamole.GuacamoleException;
import org.apache.guacamole.environment.Environment;
import org.apache.guacamole.environment.LocalEnvironment;
import org.apache.guacamole.net.auth.*;
import org.apache.guacamole.net.auth.simple.SimpleUserContext;
import org.apache.guacamole.protocol.GuacamoleConfiguration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class AwsAuthenticationProvider extends AbstractAuthenticationProvider {
    private static final Logger logger = LoggerFactory.getLogger(AwsAuthenticationProvider.class);

    private Environment environment;

    public AwsAuthenticationProvider() throws GuacamoleException {
        environment = new LocalEnvironment();
    }

    @Override
    public String getIdentifier() {
        return "aws";
    }


    public Map<String, GuacamoleConfiguration> getAuthorizedConfigurations(Credentials credentials) throws GuacamoleException {

        Configurations configurations = null;

        String awsLambdaFunction = environment.getProperty(
                AwsAuthenticationProperties.AWS_LAMBDA_FUNCTION
        );
        Boolean awsDescribeEc2Instances = environment.getProperty(AwsAuthenticationProperties.AWS_DESCRIBE_EC2_INSTANCES, false);


        if (!StringUtils.isBlank(awsLambdaFunction)) {
            try {
                logger.debug(String.format("Invoking Lambda Function %s", awsLambdaFunction));
                configurations = LambdaUtil.getConfigurations(environment, credentials);
            } catch (Exception e) {
                String errorMessage = String.format("Could not retrieve Guacamole Configurations from Lambda: %s", awsLambdaFunction);
                GuacamoleClientException exception = new GuacamoleClientException(errorMessage, e);
                logger.error(e.getMessage(), e);
                throw exception;
            }


        } else if (awsDescribeEc2Instances) {
            logger.debug("Describing EC2 Instances");

            try {
                configurations = Ec2DescribeInstancesUtil.getConfigurations(environment, credentials);
            } catch (Exception e) {
                String errorMessage = "Could not retrieve Guacamole Configurations from EC2 API";
                GuacamoleClientException exception = new GuacamoleClientException(errorMessage, e);
                logger.error(exception.getMessage(), exception);
                throw exception;
            }
        }

        if (configurations != null) {
            logger.debug("Configurations: {}", configurations.getConfigurations());
            Map<String, GuacamoleConfiguration> guacamoleConfigurationMap = configurations.asGuacamoleConfigurations();
            if (!guacamoleConfigurationMap.isEmpty()) {
                OverrideUtil.applyOverrides(environment, guacamoleConfigurationMap);
                return guacamoleConfigurationMap;
            }
        }


        return null;
    }


    @Override
    public AuthenticatedUser authenticateUser(Credentials credentials) throws GuacamoleException {
        Boolean alwaysAuthenticate = environment.getProperty(AwsAuthenticationProperties.AWS_ALWAYS_AUTHENTICATE, false);
        logger.info(String.format("AWS_ALWAYS_AUTHENTICATE: %s", alwaysAuthenticate));

        if (alwaysAuthenticate) {
            org.apache.guacamole.net.auth.AuthenticationProvider authenticationProvider = this;
            return new AbstractAuthenticatedUser() {

                @Override
                public org.apache.guacamole.net.auth.AuthenticationProvider getAuthenticationProvider() {
                    return authenticationProvider;
                }

                @Override
                public Credentials getCredentials() {
                    return credentials;
                }
            };
        }

        return null;
    }

    @Override
    public UserContext getUserContext(AuthenticatedUser authenticatedUser) throws GuacamoleException {
        logger.info("Getting AWS User Context");
        Map<String, GuacamoleConfiguration> authorizedConfigurations = getAuthorizedConfigurations(authenticatedUser.getCredentials());
        if (authorizedConfigurations != null) {

            List<String> authorizedConfigurationsStrings = new ArrayList<>();
            authorizedConfigurations.forEach((key, guacamoleConfiguration) -> {
                List<String> authorizedConfigurationAttributes = new ArrayList<>();
                authorizedConfigurationAttributes.add(String.format("connectionID = \"%s\"", guacamoleConfiguration.getConnectionID()));
                authorizedConfigurationAttributes.add(String.format("protocol = \"%s\"", guacamoleConfiguration.getProtocol()));
                List<String> authorizedConfigurationParameters = new ArrayList<>();
                guacamoleConfiguration.getParameters().forEach((parameter, value) -> authorizedConfigurationParameters.add(String.format("\"%s\" = \"%s\"", parameter, value)));
                authorizedConfigurationAttributes.add(String.format("parameters = { %s }", StringUtils.join(authorizedConfigurationParameters, ",\n")));
                authorizedConfigurationsStrings.add(String.format("%s =\n{\n%s\n}", key, StringUtils.join(authorizedConfigurationAttributes, ",\n")));
            });


            logger.debug("Authorized Configurations: {}", StringUtils.join(authorizedConfigurationsStrings, "\n"));

            return new SimpleUserContext(this, authenticatedUser.getCredentials().getUsername(), authorizedConfigurations);


        } else {
            return null;
        }
    }

}
