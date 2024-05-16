# README

Daisy Official Documentation https://daisyui.com/

Demo: https://daisyui.fly.dev/

Current Main Branch: rails 7 + esbuild

Rails 6 + webpacker: https://github.com/mkhairi/rails-daisyui-starter/tree/rails6

> # CareClan App

> Welcome to the CareClan app! This README will guide you through setting up and running the application on your local machine.

> ## Prerequisites

> - Ruby 3.2.1
> - Rails 7.0.7 or higher
> - PostgreSQL
> - Node.js
> - Yarn

> ## Getting Started

> 1. Clone the repository:

>    ```
>    git clone https://github.com/your-username/careclan-app.git
>    cd careclan-app
>    ```

> 2. Install Ruby dependencies:

>    ```
>    bundle install
>    ```

> 3. Install JavaScript dependencies:

>    ```
>    yarn install
>    ```

> 4. Set up the database:

>    ```
>    rails db:create
>    rails db:migrate
>    rake sample_data
>    ```

> ## Configuration

> - If you need to customize the database settings, update the `config/database.yml` file.
> - Set up any required environment variables or credentials for external services (e.g., AWS S3, Postmark).

> ### AWS S3 Setup

> To set up AWS S3 for file uploads, follow these steps:

> 1. Create an AWS account if you don't have one already.
> 2. Create an IAM user with programmatic access and attach the necessary permissions for S3.
> 3. Obtain the AWS access key ID and secret access key for the IAM user.
> 4. Set the `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`, and `AWS_BUCKET` environment variables in the `credentials.yml.enc` file as described below.

> ### Postmark Setup

> To set up Postmark for email delivery, follow these steps:

> 1. Create a Postmark account at https://postmarkapp.com/.
> 2. Obtain your Postmark API token from the Postmark dashboard.
> 3. Set the `POSTMARK_API_TOKEN` environment variable in the `credentials.yml.enc` file as described below.

> With the environment variables set up, the app will automatically use the provided AWS and Postmark credentials for file uploads and email delivery.

> Note: Make sure to keep your credentials secure and avoid sharing them publicly. Each user should set up their own AWS and Postmark accounts and use their respective credentials.

> ## Environment Variables

> The application requires certain environment variables to be set up in order to run properly. Follow these steps to configure the environment variables:

> 1. Create a new file named `credentials.yml.enc` in the root directory of the project.

> 2. In the terminal, run `rails credentials:edit`.

> 3. Add the following variables to the opened file:

>    ```yaml
>    aws:
>      access_key_id: your_aws_access_key_id
>      secret_access_key: your_aws_secret_access_key
>      region: your_aws_region
>      bucket: your_aws_bucket_name
>    postmark:
>      api_token: your_postmark_api_token
>    ```

>    Replace `your_aws_access_key_id`, `your_aws_secret_access_key`, `your_aws_region`, `your_aws_bucket_name`, and `your_postmark_api_token` with the actual values for your AWS and Postmark credentials.

> 4. Save the file and close the editor.

> 5. Run the following command to start the GoodJob worker:

>    ```
>    bundle exec good_job start
>    ```

> 6. Start the development server:

>    ```
>    ./bin/dev
>    ```

>    Or:

>    ```
>    rails server
>    ```

> ## User Authentication

> The app uses Devise for user authentication. To log in, use the following credentials:

> - Email: gary@example.com
> - Password: password

> These credentials work for both the production and development environments.

# Overview

1. **Logging In:** After logging in with your username and password, users gain access to their medical records.
2. **Accessing Medical Records:** Users can access their medical records once logged in. These records may include information such as past appointments, prescriptions, and medical history.
3. **Creating New Records:** Users have the option to create new records within the app. This could involve documenting new medical information, such as medication intake or symptoms, by specifying a date and record type.
4. **Sharing Medical Records:** The app allows users to share their medical records with friends and family, potentially for purposes such as seeking advice or updating loved ones on their health status.
5. **Voting on Posts:** Users can vote on their own posts within the app. This feature might be used for feedback or to track the popularity or importance of certain medical updates or discussions.
6. **Engaging in Conversations:** Users can engage in conversations within the app, likely with other users or healthcare professionals.
7. **Receiving Feedback:** Users can receive feedback from others within the app. This feedback might come from peers, healthcare professionals, or other members of the Careclan community.
8. **Managing Privacy Settings:** Manage Privacy Settings in the Clan Section by Toggling Trust.
9. **Enjoy The Content**

<hr>

# Code Review

## Documentation
- Setup and installation section is not clearly labeled. The setup section should be clearly identified so that outside developer can easily onbard onto your project. 
- No contribution guidelines
- We encourage you to review the rubric for the Documentation section! The rubric lists out the information that should be included on a basic readme file

## Code Hygiene
- Good indentation overall.
- Remove unused/blank files

## Frontend
- Responsive site
- All images are not loading in production; fix your images
- Production styling has room for improvement
- Broken toggler

## Backend
- We do not have your development key, so we were unable to onbaord/launch app in development
- We could not run your application in development. The readme setup instructions were incomplete/missing steps 
- Consider adding an authorization framework like Pundit


## Other Feedback
- Debug your pagination. It is not displaying in production
- I created a new user account. However, I was able to see all of Gary's medical records.