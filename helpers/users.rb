class Users
  attr_reader :username, :email,
              :password, :wrong_username,
              :wrong_password, :wrong_email,
              :first_name, :last_name

  def initialize
    @first_name ||=Faker::Name.first_name
    @last_name ||=Faker::Name.last_name
    if (((@first_name + @last_name).length <3) or ((@first_name + @last_name).length >11))
      @username = @first_name
    else
      @username = @first_name + @last_name
    end

  end

  def email
    @email ||=Faker::Internet.free_email(@username)
  end

  def password
    @password ||=Faker::Internet.password(8, 20)
  end
end