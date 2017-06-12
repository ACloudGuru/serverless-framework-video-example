echo "Installing global dependencies"
npm install -g serverless@1.15.2

./deploy-transcoding-pipeline-custom-resource.sh

echo "Installing function dependencies"

./install-dependencies.sh