# ruby-hello-world

<!-- markdown-link-check-disable-next-line -->
[![build](https://github.com/wahlfeld/ruby-hello-world/actions/workflows/build.yml/badge.svg)](https://github.com/wahlfeld/ruby-hello-world/actions/workflows/build.yml)

Hello,

Thank you very much for your interest in Muppet. As part of the interview
process, we would like you to deploy the attached Ruby Sinatra Application to
AWS/GCP or any other cloud provider.

## How to run locally
```
bundle install
bundle exec rackup -p 3000
```

To access the application, navigate to your browser to
<!-- markdown-link-check-disable-next-line -->
http://localhost:3000/hello-world

## Requirements

As part of the evaluation process we expect the following:
  - Infrastructure as code (eg: terraform, cloudformation, pulumi, aws cdk);
  - Solution to be scalable, highly available, secure and repeatable;
  - A README 
    - Explain your approach, considerations and assumptions you had to make
    - Your other options
    - How can we run the code and recreate the environment
    - What would you add to make this solution production ready?
    - If you had more time, what would you improve?
  - Last but not least being able to access the /hello-world endpoint and see
    hello world being return

You should expect about 2 days worth of effort to complete this. You will be
given 5 days as we understand you have personal and work commitment, feel free
to let us know if you've finished early or if you need some more time.

Please send us any materials that you created and we will have a walk-through of
what you have done afterward.

Thank you very much for your time and let us know if you have any questions.

Cheers, Team Muppet

## Dependencies

`make .deps`

## Usage

### Heroku

```
heroku login

heroku git:clone -a <NAME_OF_HEROKU_APP>
cd <NAME_OF_HEROKU_APP>

git add -A
git commit -am "feat: add helloworld app"
git push heroku main
```

e.g.
```
> heroku login
heroku: Press any key to open up the browser to login or q to exit:
Opening browser to https://cli-auth.heroku.com/auth/cli/browser/blablabla
Logging in... done
Logged in as me@gmail.com

> heroku git:remote -a wahlfeld-ruby-hello-world
set git remote heroku to https://git.heroku.com/wahlfeld-ruby-hello-world.git

> git add -A

> git commit -am "feat: add helloworld app"

> git push heroku main
Enumerating objects: 10, done.
Counting objects: 100% (10/10), done.
Delta compression using up to 4 threads
Compressing objects: 100% (6/6), done.
Writing objects: 100% (10/10), 2.80 KiB | 574.00 KiB/s, done.
Total 10 (delta 0), reused 0 (delta 0), pack-reused 0
remote: Compressing source files... done.
remote: Building source:
remote:
remote: -----> Building on the Heroku-20 stack
remote: -----> Determining which buildpack to use for this app
remote: -----> Ruby app detected
remote: -----> Installing bundler 1.17.3
remote: -----> Removing BUNDLED WITH version in the Gemfile.lock
remote: -----> Compiling Ruby/Rack
remote: -----> Using Ruby version: ruby-2.6.6
remote: -----> Installing dependencies using bundler 1.17.3
remote:        Running: BUNDLE_WITHOUT='development:test' BUNDLE_PATH=vendor/bundle BUNDLE_BIN=vendor/bundle/bin BUNDLE_DEPLOYMENT=1 BUNDLE_GLOBAL_PATH_APPENDS_RUBY_SCOPE=1 bundle install -j4
remote:        Fetching gem metadata from https://rubygems.org/....
remote:        Using bundler 1.17.3
remote:        Fetching rack 2.2.3
remote:        Fetching ruby2_keywords 0.0.2
remote:        Fetching tilt 2.0.10
remote:        Installing rack 2.2.3
remote:        Installing ruby2_keywords 0.0.2
remote:        Installing tilt 2.0.10
remote:        Fetching mustermann 1.1.1
remote:        Installing mustermann 1.1.1
remote:        Fetching rack-protection 2.1.0
remote:        Installing rack-protection 2.1.0
remote:        Fetching sinatra 2.1.0
remote:        Installing sinatra 2.1.0
remote:        Bundle complete! 1 Gemfile dependency, 7 gems now installed.
remote:        Gems in the groups development and test were not installed.
remote:        Bundled gems are installed into `./vendor/bundle`
remote:        Bundle completed (1.98s)
remote:        Cleaning up the bundler cache.
remote: -----> Detecting rake tasks
remote:
blablabla
remote:
remote: -----> Discovering process types
remote:        Procfile declares types     -> (none)
remote:        Default types for buildpack -> console, rake, web
remote:
remote: -----> Compressing...
remote:        Done: 15M
remote: -----> Launching...
remote:        Released v4
remote:        https://wahlfeld-ruby-hello-world.herokuapp.com/ deployed to Heroku
remote:
remote: Verifying deploy... done.
To https://git.heroku.com/wahlfeld-ruby-hello-world.git
 * [new branch]      main -> main
```
https://wahlfeld-ruby-hello-world.herokuapp.com/hello-world

### AWS

1. Create a Terraform backend S3 bucket to store your state files
2. Copy and paste the `template` folder somewhere on your computer
3. Configure `terraform.tf` to point at the S3 bucket you just created
4. Create a file called `terraform.tfvars` as per the input descriptions in
   `inputs.tf` E.g.
```
aws_region       = "ap-southeast-2"    // Choose a region closest to your physical location
```
5. Run `terraform init && terraform apply`

### Example folder structure

```
ruby-hello-world           // (this project)
└── your-ruby-hello-world  // (create me)
    ├── inputs.tf        // (copied from ./template)
    ├── main.tf          // (copied from ./template)
    ├── terraform.tf     // (copied from ./template)
    └── terraform.tfvars // (create me), example above)
```

### Monitoring

To view server monitoring metrics visit the `monitoring_url` output from
Terraform after deploying. Note that this URL will change every time the server
starts.

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to create the helloworld server | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | AWS EC2 instance type to run the server on | `string` | `"t3a.nano"` | no |
| <a name="input_purpose"></a> [purpose](#input\_purpose) | The purpose of the deployment | `string` | `"test"` | no |
| <a name="input_unique_id"></a> [unique\_id](#input\_unique\_id) | The ID of the deployment (used for tests) | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | The S3 bucket name |
| <a name="output_helloworld_url"></a> [helloworld\_url](#output\_helloworld\_url) | URL to the helloworld Server |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | The EC2 instance ID |
| <a name="output_monitoring_url"></a> [monitoring\_url](#output\_monitoring\_url) | URL to monitor the helloworld Server |
<!-- END_TF_DOCS -->
