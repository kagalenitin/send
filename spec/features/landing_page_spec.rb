require 'spec_helper'

feature 'Verify Landing Page' do
  let(:app) { App.new }
  let(:users) { Users.new }
  let(:messages) { YAML.load_file(File.expand_path('../../constants/messages.yml', File.dirname(__FILE__))) }
  let(:logger) { Logger.new(STDOUT) }

  before do
    app.landing_page.load
    page.driver.browser.manage.window.maximize
  end

  scenario 'should creates new account successfully',retry: 1, retry_wait: 2, regression: true, smoke: true  do
    username = users.username
    email = users.email
    password = users.password
    logger.info('Creating account for user ' + username )
    app.landing_page.create_account(username, email, password, password)
    expect(app.landing_page.sign_up_message).to have_content (messages.fetch('success_message'))
    expect(app.landing_page).to have_sign_up_message
    logger.info('Created user with ID: ' + app.landing_page.sign_up_message.text)
  end

  scenario 'should show an error when username field is invalid', retry: 1, retry_wait: 2,
           regression: true, smoke: false do
    username = "te"
    email = users.email
    password = users.password
    logger.info('Creating account for user ' + username )
    app.landing_page.create_account(username, email, password, password)
    expect(app.landing_page.error_message). to have_content (messages.fetch('username_error'))
    username = "testingtimessavesnine"
    app.landing_page.create_account(username, email, password, password)
    expect(app.landing_page.error_message). to have_content (messages.fetch('username_error'))
  end

  scenario 'should show an error when password field is invalid', retry: 1, retry_wait: 2, regression: true, smoke: true  do
    username = users.username
    email = users.email
    password = "abc"
    logger.info('Creating account for user ' + username )
    app.landing_page.create_account(username, email, password, password)
    expect(app.landing_page.error_message).to have_content (messages.fetch('password_error'))
    password = "abcabcabcabcabcabcabcabc1"
    app.landing_page.create_account(username, email, password, password)
    expect(app.landing_page.error_message).to have_content (messages.fetch('password_error'))
  end

  scenario 'should show an error when password field is all numeric', retry: 1, retry_wait: 2, regression: true, smoke: true  do
    username = users.username
    email = users.email
    password = "123456789"
    logger.info('Creating account for user ' + username )
    app.landing_page.create_account(username, email, password, password)
    expect(app.landing_page.error_message).to have_content (messages.fetch('password_numeric_error'))
  end

  scenario 'should show an error when password field is all alphabets', retry: 1, retry_wait: 2, regression: true, smoke: true  do
    username = users.username
    email = users.email
    password = "abcabcabcabcabcabc"
    logger.info('Creating account for user ' + username )
    app.landing_page.create_account(username, email, password, password)
    expect(app.landing_page.error_message).to have_content (messages.fetch('password_alpha_error'))
  end

  scenario 'should show an error when email field is invalid', retry: 1, retry_wait: 2, regression: true, smoke: true  do
    username = users.username
    email = "test@.com"
    password = users.password
    logger.info('Creating account for user ' + username )
    app.landing_page.create_account(username, email, password, password)
    expect(app.landing_page.error_message).to have_content (messages.fetch('email_error'))
  end

  scenario 'should show an error when using existing email address',retry: 1, retry_wait: 2, regression: true, smoke: true  do
    username = users.username
    email = users.email
    password = users.password
    logger.info('Creating account for user ' + username )
    app.landing_page.create_account(username, email, password, password)
    expect(app.landing_page.sign_up_message).to have_content (messages.fetch('success_message'))
    expect(app.landing_page).to have_sign_up_message
    logger.info('Created user with ID: ' + app.landing_page.sign_up_message.text)
    logger.info('Creating a new account for same email' + email )

    username = "NewUser"
    logger.info('Creating account for user ' + username )
    app.landing_page.create_account(username, email, password, password)
    expect(app.landing_page.sign_up_message).to have_content (messages.fetch('email_exists_error'))
  end
end