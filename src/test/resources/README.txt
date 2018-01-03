To test on Amazon, those environment variables are mandatory:

AWS_ACCESS_KEY_ID=
AWS_SECRET_KEY=u
AWS_REGION=eu-west-1
AWS_CLOUDIFY3_MANAGER_URL=http://52.48.32.176/
AWS_KEY_PATH=keys/amazon/alien.pem
AWS_KEY_NAME=mkv

CLOUDIFY3_MANAGER_USER
CLOUDIFY3_MANAGER_PASSWORD


Refactor:

1. To test CFY :

CFY_MANAGER_URL
CFY_MANAGER_USER
CFY_MANAGER_PASSWORD

2. To test Vault Provider, the following environment variables are necessary:

ALIEN_URL
CFY_MANAGER_URL
CFY_MANAGER_USER
CFY_MANAGER_PASSWORD
CFY_MANAGER_LOG_PORT
VAULT_URL
CERTIFICATE_PATH    (It is the path to the server certificate file.)
