# frozen_string_literal: true

require "sinatra/base"
require "sinatra/reloader"
require_relative "lib/space"
require_relative "lib/space_repository"
require_relative "lib/database_connection"
require_relative "lib/booking"
require_relative "lib/booking_repository"
require_relative "lib/user_repository"

DatabaseConnection.connect("makersbnb_test")

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    enable :sessions
    also_reload 'lib/space_repository'
    also_reload "lib/space"
  end

  post "/spaces/book/:id" do
    @message = "Booking confirmed"
    repo = SpaceRepository.new
    @space = repo.is_available?(params[:id])
    if @space.dates.include?(params[:dates])
      @message = "Unavailable on this date"
    else
      new_booking = Booking.new
      new_booking.space_id = params[:id]
      new_booking.user_id = session[:user_id]
      new_booking.booking_date = params[:dates]
      new_booking.confirmation = false
      new_booking.total_cost = @space.price
      booking_repo = BookingRepository.new
      booking_repo.create(new_booking)
    end
    #get book required to return post book
    return erb(:booking_confirmed)
  end

  get "/" do
    if session[:session_email]
      user = UserRepository.new
      @user = user.find(session[:session_email])
    end

    repo = SpaceRepository.new
    @all_spaces = repo.all
    return erb(:index)
  end


  get '/registrations/signup' do
    erb :'registrations/signup'
  end


  post '/adduser' do
    @user_repository = UserRepository.new
    new_user = User.new
    new_user.name = params[:name]
    new_user.username = params[:username]
    new_user.email = params[:email]
    new_user.password = params[:password]

    @user_repository.create(new_user)

    session[:user_id] = new_user.id

    redirect '/'
  end

  # post "/" do
  #   repo = SpaceRepository.new
  #   index = 1
  #     while index <= repo.all.length do
  #       @all_spaces = repo.all
  #       space = repo.is_available?(index)
  #         if space.dates.include?(params[:dates])
  #           @all_spaces.delete(space) 
  #         end
  #       index += 1 
  #     end
  #   redirect "/"
  # end

  ###james
  get "/spaces/new" do
    return erb(:new_space)
  end

  post "/spaces/new" do
    name = params[:name]
    description = params[:description]
    price = params[:price]
    user_id = 1   ##TESTTT

    # if user_id.nil?
    #   status 400
    #   return 'ERROR: Please log in to add a new listing'
    # end

    new_space = Space.new
    new_space.name = name
    new_space.description = description
    new_space.price = price
    new_space.user_id = user_id
    SpaceRepository.new.create(new_space)

    redirect "/"
  end

  get "/spaces/book/:id" do
    repo = SpaceRepository.new
    @space = repo.find(params[:id])
    if (params[:id]).to_i > repo.all.length
      redirect "/"
    elsif session[:session_user_id] == nil
      redirect '/sessions/login'
    else
      return erb(:book)
    end
  end

  get "/spaces/:id" do
    repo = SpaceRepository.new
    if (params[:id]).to_i > repo.all.length
      redirect "/"
    else
      @space = repo.find(params[:id])
      return erb(:spaces)
    end
  end

 get '/mybookings/:id' do
    #@session_id = 1 #sessions[:id]
    #if sessions[:id] == params[:id]
    #flash error message
    #redirect "/"
    #else
    repo = BookingRepository.new
    @renter_bookings = repo.find_by_renter(params[:id])
    new_repo = BookingRepository.new
    @host_bookings = new_repo.bookings_by_owner(params[:id])
    return erb(:mybookings)
  end

  post "/mybookings/success/:id" do
    repo = BookingRepository.new
    params = [params[:booking_id]]
    query = "UPDATE SET confirmation = true WHERE id = $1"
    DatabaseConnection.exec_params(query, params)
    return erb(:booking_confirmed)
  end

  get "/mybookings/success/:id" do
    return erb(:booking_confirmed)
  end

  #get '/requests/:id' do

  post "/sessions" do
    repo = UserRepository.new

    user = repo.find(params[:email])
    users = repo.all
    email = params[:email]
    password = params[:password]
    return erb :'sessions/login' if users.any? { |user| user.email == email } == false
    login = repo.sign_in(email, password)

    # if user == "incorrect"
    #   return erb :"sessions/login"
    # end
    if login == "correct"
      session[:session_user_id] = user.id
      session[:session_email] = user.email
      p session
      redirect "/"
    else
      # @message = incorrect login details
      return erb :'sessions/login'
    end
  end

  get "/sessions/login" do
    erb :"sessions/login"
  end

  post "/logout" do
    session[:session_user_id] = nil
    session[:session_email] = nil
    repo = SpaceRepository.new
    @all_spaces = repo.all

    erb :index
  end
end
