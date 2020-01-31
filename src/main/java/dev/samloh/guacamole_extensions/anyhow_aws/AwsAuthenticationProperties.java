package dev.samloh.guacamole_extensions.anyhow_aws;

import org.apache.guacamole.properties.BooleanGuacamoleProperty;
import org.apache.guacamole.properties.StringGuacamoleProperty;

public class AwsAuthenticationProperties {
    public static final StringGuacamoleProperty AWS_PROFILE =
            new StringGuacamoleProperty() {
                @Override
                public String getName() {
                    return "aws-profile";
                }
            };

    public static final StringGuacamoleProperty AWS_LAMBDA_FUNCTION =
            new StringGuacamoleProperty() {

                @Override
                public String getName() {
                    return "aws-lambda-function";
                }
            };
    public static final StringGuacamoleProperty AWS_LAMBDA_USERNAME_KEY =
            new StringGuacamoleProperty() {

                @Override
                public String getName() {
                    return "aws-lambda-username-key";
                }
            };
    public static final String DEFAULT_AWS_LAMBDA_USERNAME_KEY = "GUACAMOLE_USERNAME";
    public static final StringGuacamoleProperty AWS_LAMBDA_REMOTE_ADDRESS_KEY =
            new StringGuacamoleProperty() {

                @Override
                public String getName() {
                    return "aws-lambda-remote-address-key";
                }
            };
    public static final String DEFAULT_AWS_LAMBDA_REMOTE_ADDRESS_KEY = "GUACAMOLE_REMOTE_ADDRESS";
    public static final StringGuacamoleProperty AWS_LAMBDA_REMOTE_HOSTNAME_KEY =
            new StringGuacamoleProperty() {

                @Override
                public String getName() {
                    return "aws-lambda-remote-hostname-key";
                }
            };
    public static final String DEFAULT_AWS_LAMBDA_REMOTE_HOSTNAME_KEY = "GUACAMOLE_REMOTE_HOSTNAME";


    public static final StringGuacamoleProperty AWS_OVERRIDE_TYPESCRIPT_PATH = new StringGuacamoleProperty() {

        @Override
        public String getName() {
            return "aws-override-typescript-path";
        }
    };
    public static final BooleanGuacamoleProperty AWS_OVERRIDE_CREATE_TYPESCRIPT_PATH = new BooleanGuacamoleProperty() {
        @Override
        public String getName() {
            return "aws-override-create-typescript-path";
        }
    };

    public static final StringGuacamoleProperty AWS_OVERRIDE_TYPESCRIPT_NAME = new StringGuacamoleProperty() {

        @Override
        public String getName() {
            return "aws-override-typescript-name";
        }
    };
    public static final StringGuacamoleProperty AWS_OVERRIDE_RECORDING_PATH = new StringGuacamoleProperty() {

        @Override
        public String getName() {
            return "aws-override-recording-path";
        }
    };
    public static final BooleanGuacamoleProperty AWS_OVERRIDE_CREATE_RECORDING_PATH = new BooleanGuacamoleProperty() {
        @Override
        public String getName() {
            return "aws-override-create-recording-path";
        }
    };
    public static final StringGuacamoleProperty AWS_OVERRIDE_RECORDING_NAME = new StringGuacamoleProperty() {

        @Override
        public String getName() {
            return "aws-override-recording-name";
        }
    };
    public static final BooleanGuacamoleProperty AWS_OVERRIDE_RECORDING_EXCLUDE_OUTPUT = new BooleanGuacamoleProperty() {
        @Override
        public String getName() {
            return "aws-override-recording-exclude-output";
        }
    };
    public static final BooleanGuacamoleProperty AWS_OVERRIDE_RECORDING_EXCLUDE_MOUSE = new BooleanGuacamoleProperty() {

        @Override
        public String getName() {
            return "aws-override-recording-exclude-mouse";
        }
    };
    public static final BooleanGuacamoleProperty AWS_OVERRIDE_RECORDING_INCLUDE_KEYS = new BooleanGuacamoleProperty() {
        @Override
        public String getName() {
            return "aws-override-recording-include-keys";
        }
    };
    public static final BooleanGuacamoleProperty AWS_OVERRIDE_ENABLE_SFTP = new BooleanGuacamoleProperty() {
        @Override
        public String getName() {
            return "aws-override-enable-sftp";
        }
    };
    public static final StringGuacamoleProperty AWS_OVERRIDE_SFTP_ROOT_DIRECTORY = new StringGuacamoleProperty() {
        @Override
        public String getName() {
            return "aws-override-sftp-root-directory";
        }
    };

    public static final BooleanGuacamoleProperty AWS_DESCRIBE_EC2_INSTANCES = new BooleanGuacamoleProperty() {
        @Override
        public String getName() {
            return "aws-describe-ec2-instances";
        }
    };


    public static final BooleanGuacamoleProperty AWS_DESCRIBE_EC2_INSTANCES_FILTER_BY_INSTANCE_VPC_ID = new BooleanGuacamoleProperty() {
        @Override
        public String getName() {
            return "aws-describe-ec2-instances-filter-by-instance-vpc-id";
        }
    };

    public static final StringGuacamoleProperty AWS_DESCRIBE_EC2_INSTANCES_FILTER_VPC_ID = new StringGuacamoleProperty() {
        @Override
        public String getName() {
            return "aws-describe-ec2-instances-filter-vpc-id";
        }
    };
    public static final StringGuacamoleProperty AWS_DESCRIBE_EC2_INSTANCES_FILTER_SUBNET_ID = new StringGuacamoleProperty() {
        @Override
        public String getName() {
            return "aws-describe-ec2-instances-filter-subnet-id";
        }
    };
    public static final StringGuacamoleProperty AWS_DESCRIBE_EC2_INSTANCES_FILTER_INSTANCE_GROUP_NAME = new StringGuacamoleProperty() {
        @Override
        public String getName() {
            return "aws-describe-ec2-instances-filter-instance-group-name";
        }
    };
    public static final StringGuacamoleProperty AWS_DESCRIBE_EC2_INSTANCES_FILTER_INSTANCE_GROUP_ID = new StringGuacamoleProperty() {
        @Override
        public String getName() {
            return "aws-describe-ec2-instances-filter-instance-group-id";
        }
    };


    public static final BooleanGuacamoleProperty AWS_ALWAYS_AUTHENTICATE = new BooleanGuacamoleProperty() {
        @Override
        public String getName() {
            return "aws-always-authenticate";
        }
    };


    private AwsAuthenticationProperties() {
    }


}
