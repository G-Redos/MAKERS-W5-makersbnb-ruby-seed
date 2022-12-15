# frozen_string_literal: true

require "spec_helper"
require "rack/test"
require_relative "../../app"
require "json"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  before(:each) do
    query = File.read('./spec/seeds/bnb_test_tables.sql')
    connection = PG.connect({ host: "127.0.0.1", dbname: "makersbnb_test" })
    connection.exec(query)
  end

  context "GET /" do
    it "should get the homepage" do
      response = get("/")

      expect(response.status).to eq(200)
      expect(response.body).to include("Cabin")
      expect(response.body).to include("Cozy Cool Cabin")
    end
  end


  context 'GET/signup' do
    it 'should get the signup page' do
      response = get('/registrations/signup') 

      expect(response.status).to eq(200)
      expect(response.body).to include('<form action="/adduser" method="POST">')
    end
  end

  context 'POST /adduser' do
    it 'should create a user' do
      _response = post(
        '/index',
        '/adduser',
        name: 'auser',
        username: 'a_user',
        email: 'auser@email.com',
        password: '123abc'
      )

      response = get('/index')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h3>Add a new space</h3>')
    end
  end

  context "GET /spaces/new" do
    it "show new space page" do
      response = get("/spaces/new")
      expect(response.status).to eq 200
      expect(response.body).to include ("<h1>List a Space</h1>")
    end
  end
