const AWS = require('aws-sdk');
const Promise = require('bluebird');
const _ = require('lodash');

AWS.config.apiVersions = {
    ec2: '2016-11-15'
};
AWS.config.region = 'ap-southeast-1';
AWS.config.setPromisesDependency(Promise);

exports.handler = function (event, context, callback) {

    let ec2 = new AWS.EC2();

    let vpcIds = _.get(process.env, 'VPC_IDS', "");
    if (!_.isEmpty(vpcIds)) {
        vpcIds = _.split(vpcIds, /[ ,]+/);
    }

    let debug = _.get(process.env, 'DEBUG', "false");


    let filters = [];

    if (!_.isEmpty(vpcIds)) {
        filters.push({
            Name: "vpc-id",
            Values: vpcIds
        })
    }

    let params = {};

    if (!_.isEmpty(filters)) {
        _.set(params, 'Filters', filters);
    } else {
        params = null;
    }

    return ec2.describeInstances(params)
        .promise()
        .then(function (response) {

            let instances = _.flatten(_.map(response.Reservations, 'Instances'));
            let configurations = _.map(instances, function (instance) {
                let configuration = {};
                let configurationId = _.get(_.find(instance.Tags, {Key:'Name'}), 'Value', _.get(instance, 'InstanceId'));
                _.set(configuration, 'configurationId', configurationId);
                if (_.lowerCase(instance.Platform) === "windows") {
                    _.set(configuration, 'protocol', 'rdp');
                    _.set(configuration, ['parameters', 'hostname'], instance.PrivateIpAddress);
                    _.set(configuration, ['parameters', 'port'], '3389');
                    _.set(configuration, ['parameters', 'security'], 'tls');
                    _.set(configuration, ['parameters', 'ignore-cert'], 'true');
                    _.set(configuration, ['parameters', 'disable-auth'], 'true');

                } else {
                    _.set(configuration, 'protocol', 'ssh');
                    _.set(configuration, ['parameters', 'hostname'], instance.PrivateIpAddress);
                    _.set(configuration, ['parameters', 'port'], '22');
                }

                return configuration;
            });

            return {"configurations": configurations};
        })
        .tap(function (configurations) {
            if (debug === "true") {
                console.debug(configurations);
            }
        });
};
