const amplifyconfig = ''' {
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "ap-northeast-1:0f553f89-d19e-4591-a5d3-f8a693555798",
                            "Region": "ap-northeast-1"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "ap-northeast-1_trzVUOHq5",
                        "AppClientId": "6m5l49a96o0icg7n57e2gd3n78",
                        "AppClientSecret": "1nknk089frtm48u444vr5dcf24o309k6plrq3j94dk3tfp01tnj0",
                        "Region": "ap-northeast-1"
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "USER_SRP_AUTH"
                    }
                }
            }
        }
    }
}''';