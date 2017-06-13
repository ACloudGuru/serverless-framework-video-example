# serverless-framework-video-example
A serverless video sharing application example using Serverless Framework

# Disclaimer
**These steps are for linux or OSX systems. All of this is achievable using Windows but those instructions have not been provided. Please feel free to issue a pull request with windows instructions. Most if not all the shell script steps should have a direct translation to powershell or batch scripts in Windows.**

**This is not a production ready video transcoding pipeline. Variables are stored unencrypted in the Lambda configuration, many configuration steps are still manual due to limitations with how Serverless Framework and CloudFormation interact, and services that are missing from CloudFormation. Most of these issues can be resolved by using Ansible to orchestrate the entire project deployment**

# Setup
## Dependencies
* AWS Account
* AWS CLI [https://aws.amazon.com/cli/](https://aws.amazon.com/cli/)
* Node 6.10.x

## Configuration Steps
1. Install the dependencies listed above.
2. In the same directory as this README run the following shell command
    ```
    ./setup.sh
    ```
3. Create an IAM user in your AWS account with the following inline policy where `YOUR_UPLOAD_BUCKET_NAME` matches the one you will be using in step 4. Save the new user's `ACCESS_KEY_ID` and `SECRET_ACCESS_KEY` for use in step 4.
    ```
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "s3:ListBucket"
                ],
                "Resource": [
                    "arn:aws:s3:::YOUR_UPLOAD_BUCKET_NAME"
                ]
            },
            {
                "Effect": "Allow",
                "Action": [
                    "s3:PutObject"
                ],
                "Resource": [
                    "arn:aws:s3:::YOUR_UPLOAD_BUCKET_NAME/*"
                ]
            }
        ]
    }
    ```
4. Create a configuration file for your stage in the `backend` directory based on the example config `config-stage.example.yml`. The name of the file should be in the format `config-<your-stage-name>.yml`. You can ignore the variable ELASTIC_TRANSCODER_PIPELINE_ID until a later step. The steps to fetch most of the variables required for this config file are given in the workshop handouts you should already have. Step 3 covers the `ACCESS_KEY` and `SECRET_ACCESS_KEY` variables. *Note that `ACCESS_KEY` in this step is the `ACCESS_KEY_ID` from step 3.
5. In the `website/js` directory create a `config.js` file based on the `config.example.js` file given and also copy your firebase config object into line 66 of the file `video-controller.js`.

## Deployment Steps
1. Change into the `backend` directory.
    ```
    cd backend
    ```
2. Deploy the serverless project. `<your-aws-profile>` should be the name of the profile in your `~/.aws/credentials` file that you want to use to deploy this service.
    ```
    sls -s <your-stage-name> deploy --aws-profile <your-aws-profile>
    ```
3. Login to your AWS console and configure an Elastic Transcoder Pipeline with the upload and transcoded buckets set to the same ones in your serverless project.
4. Copy the Elastic Transcoder Pipeline ID into your stage configuration file in the `backend` directory.
5. Copy the API gateway base url into your `website/js/config.js` file.
6. Run step 2. again to deploy your serverless framework project once more with the pipeline ID included this time.

## Run
1. `cd website`
2. `npm run start`
3. Open your browser to [http://localhost:8100](http://localhost:8100)

## Support
For help, please ask a question in the project's [gitter community](https://gitter.im/serverless-framework-video-example)