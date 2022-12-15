
require "users"
require 'user'
require 'user_repository'


def reset_users_table
  seed_sql = File.read("spec/seeds/bnb_test_tables.sql")
  connection = PG.connect({ host: "127.0.0.1", dbname: "makersbnb_test" })
  connection.exec(seed_sql)
end

describe UserRepository do
  before(:each) do
    reset_users_table
  end

  it "finds all users" do
    repo = UserRepository.new

    users = repo.all

    expect(users.length).to eq(5)
    expect(users.first.name).to eq("James Beans")
    expect(users[2].name).to eq("Quint Befton")
    expect(users.first.username).to eq("jb455")
  end

  it "finds a user by email" do
    repo = UserRepository.new

    user = repo.find("budweiser@budweiser.com")

    expect(user.id).to eq(2)
    expect(user.name).to eq("Harrison Beef")
    expect(user.username).to eq("beefer44")
  end

  it "finds another user by email" do
    repo = UserRepository.new

    user = repo.find("garyokay@yahoo.com")

    expect(user.id).to eq(4)
    expect(user.name).to eq("Garrison DeSpurn")
    expect(user.username).to eq("lilbean22")
  end

  it "creates a user" do
    repo = UserRepository.new

    new_user = User.new
    new_user.name = "New User"
    new_user.username = "newusername"
    new_user.email = "fake@email.com"
    new_user.password = "123456"
    repo.create(new_user)

    users = repo.all

    expect(users.length).to eq(6)
    expect(users.last.name).to eq("New User")
    expect(users.last.email).to eq("fake@email.com")
  end

  it "finds a incorrect email" do
    repo = UserRepository.new
    result = repo.find("adaoun@gmail.com")
    expect(result).to eq ""
  end
end
