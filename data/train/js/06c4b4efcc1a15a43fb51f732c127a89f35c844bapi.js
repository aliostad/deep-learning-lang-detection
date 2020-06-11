import { aws } from '../aws';

export const getApi = (apiId, region) => new Promise((resolve, reject) => aws([
    'apigateway',
    'get-rest-api',
    '--rest-api-id', apiId,
    '--region', region
])
    .then(api => {
        resolve({api: {...api, region}});
    }, reject)
);

export const createDeployApi = ({apiId, stageName}) => () => new Promise((resolve, reject) => aws([
    'apigateway',
    'create-deployment',
    '--rest-api-id', apiId,
    '--stage-name', stageName
])
    .then(resolve, reject)
);