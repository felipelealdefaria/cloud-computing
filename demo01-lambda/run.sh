# 1º passo: criar arquivos de politicas de seguranca;
# 2º passo: criar role de seguranca na aws;

aws iam create-role \
  --role-name lambda-example \
  --assume-role-policy-document file://politicas.json \
  | tee logs/role.log

# 3º passo: criar um arquivo com conteudo e zipa-lo 

zip function.zip index.js

aws lambda create-function \
  --function-name hi-cli \
  --zip-file fileb://function.zip \
  --handler index.handler \
  --runtime nodejs12.x \
  --role arn:aws:iam::095121603975:role/lambda-examples \
  | tee logs/lambda-create.log

# 4º passo: invoke lambda

aws lambda invoke \
  --function-name hi-cli \
  --log-type Tail \
  logs/lambda-exec.log

# -- se o arquivo .js for alterado, zipar novamente

zip function.zip index.js

# -- atualizar lambda

aws lambda update-function-code \
  --zip-file fileb://function.zip \
  --function-name hello-cli \
  --publish \
  | tee logs/lambda-update.log

# -- invokar e ver resultado

aws lambda invoke \
  --function-name hello-cli \
  --log-type Tail \
  logs/lambda-exec-update.log

# -- remover lambda e iam

aws lambda delete-function \
  --function-name hello-cli \

aws iam delete-role \
  --role-name lambda-example

mikhail.io/serverless/coldstarts/aws/