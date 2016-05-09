require 'spec_helper'

feature 'Landing API' do
  let(:users) { Users.new }
  let(:messages) { YAML.load_file(File.expand_path('../../constants/messages.yml', File.dirname(__FILE__))) }
  let(:logger) { Logger.new(STDOUT) }

  scenario 'create a successful user account', retry: 2, retry_wait: 2 do
    username = users.username
    email = users.email
    password = users.password
    response = Curl.post(QAEVAL_API_URL+'/api/users', {:username => username, :email => email,
                                                       :password => password})
    puts response.body_str
    json_response = JSON.parse(response.body_str)

    expect(response.status).to eq("201 Created")
  end

  scenario 'get user details', retry: 2, retry_wait: 2,
           regression: true, smoke: true do
    username = users.username
    email = users.email
    password = users.password
    response = Curl.post(QAEVAL_API_URL+'/api/users', {:username => username, :email => email,
                                                       :password => password})
    json_response = JSON.parse(response.body_str)
    user_id = json_response["userid"]
    url = QAEVAL_API_URL+'/api/users/' + user_id.to_s
    response = Curl.get(url)
    expect(response.status).to eq("200 OK")
  end

  scenario 'failure returns a 403', retry: 2, retry_wait: 2,
          regression: true, smoke: true do
    username = "ts"
    email = "st@gm"
    password = "123"
    response = Curl.post(QAEVAL_API_URL+'/api/users', {:username => username, :email => email,
                                                       :password => password})
    expect(response.status).to eq("403 Forbidden")
  end

  scenario 'get 404 for unknown user', retry: 2, retry_wait: 2,
           regression: true, smoke: true do
    response = Curl.get(QAEVAL_API_URL+'/api/users/12345')
    expect(response.status).to eq("404 Not Found")
  end

  scenario 'validate username when length is 2', retry: 2, retry_wait: 2,
           regression: true, smoke: true do
    username = "ts"
    email = users.email
    password = users.password
    response = Curl.post(QAEVAL_API_URL+'/api/users', {:username => username, :email => email,
                                                       :password => password}) do |response|
      response.headers["Content-Type"] = ["application/json"]
    end
    puts response.body_str
    json_response = JSON.parse(response.body_str)
    expect(response.status).to eq("400 Bad Request")
  end

  scenario 'validate username when length is 12', retry: 2, retry_wait: 2,
           regression: true, smoke: true do
    username = "abcdysoroele"
    email = users.email
    password = users.password
    response = Curl.post(QAEVAL_API_URL+'/api/users', {:username => username, :email => email,
                                                       :password => password}) do |response|
      response.headers["Content-Type"] = ["application/json"]
    end
    puts response.body_str
    json_response = JSON.parse(response.body_str)
    expect(response.status).to eq("400 Bad Request")
  end

  scenario 'validate email is incorrect', retry: 2, retry_wait: 2,
           regression: true, smoke: true do
    username = users.username
    email = "kgn@gm"
    password = users.password
    response = Curl.post(QAEVAL_API_URL+'/api/users', {:username => username, :email => email,
                                                       :password => password}) do |response|
      response.headers["Content-Type"] = ["application/json"]
    end
    puts response.body_str
    json_response = JSON.parse(response.body_str)
    expect(response.status).to eq("400 Bad Request")
  end

  scenario 'validate email already exists', retry: 2, retry_wait: 2 do
    username = users.username
    email = users.email
    password = users.password
    response = Curl.post(QAEVAL_API_URL+'/api/users', {:username => username, :email => email,
                                                       :password => password})
    puts response.body_str
    json_response = JSON.parse(response.body_str)

    expect(response.status).to eq("201 Created")

    logger.info('Creating a new account for same email' + email )
    username = "New"+username
    response = Curl.post(QAEVAL_API_URL+'/api/users', {:username => username, :email => email,
                                                       :password => password}) do |response|
      response.headers["Content-Type"] = ["application/json"]
    end
    puts response.body_str
    json_response = JSON.parse(response.body_str)
    expect(response.status).to eq("400 Bad Request")
  end

  scenario 'validate password is invalid length', retry: 2, retry_wait: 2,
           regression: true, smoke: true do
    username = users.username
    email = users.email
    password = "abcxyz"
    response = Curl.post(QAEVAL_API_URL+'/api/users', {:username => username, :email => email,
                                                       :password => password}) do |response|
      response.headers["Content-Type"] = ["application/json"]
    end
    puts response.body_str
    json_response = JSON.parse(response.body_str)
    expect(response.status).to eq("400 Bad Request")
    logger.info("Changed password to be more than 20 characters")
    password = "abcxyzjadjkajksdjkasdjkaskj"
    response = Curl.post(QAEVAL_API_URL+'/api/users', {:username => username, :email => email,
                                                       :password => password}) do |response|
      response.headers["Content-Type"] = ["application/json"]
    end
    puts response.body_str
    json_response = JSON.parse(response.body_str)
    expect(response.status).to eq("400 Bad Request")
  end

  scenario 'validate password is all alphabets', retry: 2, retry_wait: 2,
           regression: true, smoke: true do
    # CURL call to handle all alphabets for password fails.
    username = users.username
    email = users.email
    password = "abcabcabcbab"
    response = Curl.post(QAEVAL_API_URL+'/api/users', {:username => username, :email => email, :password => password})
    puts response.body_str
    json_response = JSON.parse(response.body_str)
    expect(response.status).to eq("400 Bad Request")
  end

  scenario 'validate password is all numeric', retry: 2, retry_wait: 2,
           regression: true, smoke: true do
    # CURL call to handle all numeric for password fails.
    username = users.username
    email = users.email
    password = "11111112333"
    response = Curl.post(QAEVAL_API_URL+'/api/users', {:username => username, :email => email, :password => password})
    puts response.body_str
    json_response = JSON.parse(response.body_str)
    expect(response.status).to eq("400 Bad Request")
  end
end