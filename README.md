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

# features
The /spec/features contains all the UI tests

# api_features
The /spec/api_features contains all the API tests

# pages
The /spec/pages contains elements related to each page on the UI. It also uses page object model.

# constants
Any constants related to config, validation messages etc.

