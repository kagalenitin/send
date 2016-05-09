# Send Grid QA Eval
This repository is a ruby solution to the QA Eval project.
It uses site-prism, Capybara, and CURB for writing UI and API tests respectively.

# Pre-requisite
 Install ruby ver. 2.2.1

# Download and Run
1. Checkout the code from the repository
2. From the root of the project, run the command bundle install
3. To run the UI Tests:
    APP_HOST=http://qaeval.herokuapp.com bundle exec rake all
4. To run the API Tests:
    APP_HOST=http://qaeval.herokuapp.com bundle exec rake api_all

