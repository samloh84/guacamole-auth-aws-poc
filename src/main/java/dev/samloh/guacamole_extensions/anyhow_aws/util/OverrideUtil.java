package dev.samloh.guacamole_extensions.anyhow_aws.util;

import dev.samloh.guacamole_extensions.anyhow_aws.AwsAuthenticationProperties;
import org.apache.guacamole.GuacamoleException;
import org.apache.guacamole.environment.Environment;
import org.apache.guacamole.protocol.GuacamoleConfiguration;

import java.util.Map;

public class OverrideUtil {
    public static void applyOverrides(Environment environment, Map<String, GuacamoleConfiguration> configurations) throws GuacamoleException {


        String overrideTypescriptName = environment.getProperty(AwsAuthenticationProperties.AWS_OVERRIDE_TYPESCRIPT_NAME);
        String overrideTypescriptPath = environment.getProperty(AwsAuthenticationProperties.AWS_OVERRIDE_TYPESCRIPT_PATH);
        Boolean overrideCreateTypescriptPath = environment.getProperty(AwsAuthenticationProperties.AWS_OVERRIDE_CREATE_TYPESCRIPT_PATH, false);

        String overrideRecordingName = environment.getProperty(AwsAuthenticationProperties.AWS_OVERRIDE_RECORDING_NAME);
        String overrideRecordingPath = environment.getProperty(AwsAuthenticationProperties.AWS_OVERRIDE_RECORDING_PATH);
        Boolean overrideCreateRecordingPath = environment.getProperty(AwsAuthenticationProperties.AWS_OVERRIDE_CREATE_RECORDING_PATH, false);
        Boolean overrideRecordingExcludeOutput = environment.getProperty(AwsAuthenticationProperties.AWS_OVERRIDE_RECORDING_EXCLUDE_OUTPUT, false);
        Boolean overrideRecordingExcludeMouse = environment.getProperty(AwsAuthenticationProperties.AWS_OVERRIDE_RECORDING_EXCLUDE_MOUSE, false);
        Boolean overrideRecordingIncludeKeys = environment.getProperty(AwsAuthenticationProperties.AWS_OVERRIDE_RECORDING_INCLUDE_KEYS, false);

        Boolean overrideEnableSftp = environment.getProperty(AwsAuthenticationProperties.AWS_OVERRIDE_ENABLE_SFTP, false);
        String overrideSftpRootDirectory = environment.getProperty(AwsAuthenticationProperties.AWS_OVERRIDE_SFTP_ROOT_DIRECTORY);


        configurations.forEach((key, guacamoleConfiguration) -> {
            if (guacamoleConfiguration.getProtocol().equals("ssh") && overrideTypescriptPath != null) {
                guacamoleConfiguration.setParameter("typescript-path", overrideTypescriptPath);

                if (overrideCreateTypescriptPath != null) {
                    guacamoleConfiguration.setParameter("create-typescript-path", String.valueOf(overrideCreateTypescriptPath));
                }

                if (overrideTypescriptName != null) {
                    guacamoleConfiguration.setParameter("typescript-name", overrideTypescriptName);
                }
            }

            if ((guacamoleConfiguration.getProtocol().equals("rdp") || guacamoleConfiguration.getProtocol().equals("vnc")) && overrideRecordingPath != null) {
                guacamoleConfiguration.setParameter("recording-path", overrideRecordingPath);

                if (overrideCreateRecordingPath != null) {
                    guacamoleConfiguration.setParameter("create-recording-path", String.valueOf(overrideCreateRecordingPath));
                }

                if (overrideRecordingName != null) {
                    guacamoleConfiguration.setParameter("recording-name", overrideRecordingName);
                }

                if (overrideRecordingExcludeMouse != null) {
                    guacamoleConfiguration.setParameter("recording-exclude-mouse", String.valueOf(overrideRecordingExcludeMouse));
                }

                if (overrideRecordingExcludeOutput != null) {
                    guacamoleConfiguration.setParameter("recording-exclude-output", String.valueOf(overrideRecordingExcludeOutput));
                }

                if (overrideRecordingIncludeKeys != null) {
                    guacamoleConfiguration.setParameter("recording-include-keys", String.valueOf(overrideRecordingIncludeKeys));
                }

            }

            if (overrideEnableSftp != null) {
                guacamoleConfiguration.setParameter("enable-sftp", String.valueOf(overrideEnableSftp));

                if (overrideSftpRootDirectory != null) {
                    guacamoleConfiguration.setParameter("sftp-root-directory", overrideSftpRootDirectory);
                }
            }

        });

    }
}
