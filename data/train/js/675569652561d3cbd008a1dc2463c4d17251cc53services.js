var services = {

    '/amazon/autoscaling' : {
        title    : 'AutoScaling',
        provider : 'amazon',
        service  : 'autoscaling',
    },

    '/amazon/cloudformation' : {
        title    : 'CloudFormation',
        provider : 'amazon',
        service  : 'cloudformation',
    },

    '/amazon/cloudfront' : {
        title    : 'CloudFront',
        provider : 'amazon',
        service  : 'cloudfront',
    },

    '/amazon/cloudsearch' : {
        title    : 'CloudSearch',
        provider : 'amazon',
        service  : 'cloudsearch',
    },

    '/amazon/cloudwatch' : {
        title    : 'CloudWatch',
        provider : 'amazon',
        service  : 'cloudwatch',
    },

    '/amazon/dynamodb' : {
        title    : 'DynamoDB',
        provider : 'amazon',
        service  : 'dynamodb',
    },

    '/amazon/ec2' : {
        title    : 'Elastic Compute Cluster (EC2)',
        provider : 'amazon',
        service  : 'ec2',
    },

    '/amazon/elasticache' : {
        title    : 'ElastiCache',
        provider : 'amazon',
        service  : 'elasticache',
    },

    '/amazon/elasticbeanstalk' : {
        title    : 'Elastic Beanstalk',
        provider : 'amazon',
        service  : 'elasticbeanstalk',
    },

    '/amazon/elb' : {
        title    : 'Elastic Load Balancing (ELB)',
        provider : 'amazon',
        service  : 'elb',
    },

    '/amazon/emr' : {
        title    : 'Elastic MapReduce (EMR)',
        provider : 'amazon',
        service  : 'emr',
    },

    '/amazon/fps' : {
        title    : 'Flexible Payments Service (FPS)',
        provider : 'amazon',
        service  : 'fps',
    },

    '/amazon/glacier' : {
        title    : 'Glacier',
        provider : 'amazon',
        service  : 'glacier',
    },

    '/amazon/iam' : {
        title    : 'Identity and Access Management (IAM)',
        provider : 'amazon',
        service  : 'iam',
    },

    '/amazon/imd' : {
        title    : 'Instance MetaData (IMD)',
        provider : 'amazon',
        service  : 'imd',
    },

    '/amazon/importexport' : {
        title    : 'ImportExport',
        provider : 'amazon',
        service  : 'importexport',
    },

    '/amazon/rds' : {
        title    : 'Relational Database Service (RDS)',
        provider : 'amazon',
        service  : 'rds',
    },

    '/amazon/redshift' : {
        title    : 'RedShift',
        provider : 'amazon',
        service  : 'redshift',
    },

    '/amazon/route53' : {
        title    : 'Route53',
        provider : 'amazon',
        service  : 'route53',
    },

    '/amazon/s3' : {
        title    : 'Simple Storage Service (S3)',
        provider : 'amazon',
        service  : 's3',
    },

    '/amazon/ses' : {
        title    : 'Simple Email Service (SES)',
        provider : 'amazon',
        service  : 'ses',
    },

    '/amazon/simpledb' : {
        title    : 'SimpleDB',
        provider : 'amazon',
        service  : 'simpledb',
    },

    '/amazon/sns' : {
        title    : 'Simple Notification Service (SNS)',
        provider : 'amazon',
        service  : 'sns',
    },

    '/amazon/sqs' : {
        title    : 'Simple Queue Service (SQS)',
        provider : 'amazon',
        service  : 'sqs',
    },

    '/amazon/storagegateway' : {
        title    : 'StorageGateway',
        provider : 'amazon',
        service  : 'storagegateway',
    },

    '/amazon/sts' : {
        title    : 'Simple Token Service (STS)',
        provider : 'amazon',
        service  : 'sts',
    },

};

Object.keys(services).forEach(function(key, i) {
    var service = services[key];
    service.name      = [ 'awssum', service.provider, service.service ].join('-');
    service.operation = require('../node_modules/awssum-' + service.provider + '-' + service.service + '/config.js');
    service.package   = require('../node_modules/awssum-' + service.provider + '-' + service.service + '/package.json');

    service.submenu = [
        { title : 'Installing', href : '/amazon/' + service.service + '/installing' },
        { title : 'Example',    href : '/amazon/' + service.service + '/example'    },
    ];
});

module.exports = services;
