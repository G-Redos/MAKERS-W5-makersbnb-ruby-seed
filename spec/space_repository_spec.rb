# frozen_string_literal: true

require "space"
require "space_repository"

def reset_spaces_table
  seed = File.read("spec/seeds/bnb_test_tables.sql")
  connection = PG.connect({ host: "127.0.0.1", dbname: "makersbnb_test" })
  connection.exec(seed)
end

describe SpaceRepository do
  before(:each) do
    reset_spaces_table
  end

  context "Display all Method" do
    it "displays all spaces" do
      repo = SpaceRepository.new
      spaces = repo.all

      expect(spaces.length).to eq 3
      expect(spaces.first.name).to eq "Beach House"
      expect(spaces.first.description).to eq "House beach for five people located in the east spain"
      expect(spaces.first.price).to eq 1000
      expect(spaces.first.user_id).to eq 3
    end
  end

  context "Find Method" do
    it "Finds a specific space by id" do
      repo = SpaceRepository.new
      space = repo.find(2)

      expect(space.id).to eq 2
      expect(space.name).to eq "The Brooklyn Penhouse"
      expect(space.description).to eq "A pent house located in central brooklyn with ten rooms"
      expect(space.price).to eq 500
      expect(space.user_id).to eq 1
    end
  end

  context "Create Method" do
    it "creates a new space" do
      repo = SpaceRepository.new

      new_space = Space.new
      new_space.name = "Windy"
      new_space.description = "Treehouse"
      new_space.price = 50
      new_space.user_id = 1
      repo.create(new_space)
      spaces = repo.all

      expect(spaces.length).to eq 4
      expect(spaces.last.name).to eq "Windy"
    end
  end

  context "Update Method" do
    it "updates an existing spaces name" do
      repo = SpaceRepository.new
      space = repo.find(1)
      space.name = "blah"
      repo.update_name(space)
      expect(space.name).to eq "blah"
    end

    it "updates an existing spaces name" do
      repo = SpaceRepository.new
      space = repo.find(1)
      space.description = "blah"
      repo.update_description(space)
      expect(space.description).to eq "blah"
    end

    it "updates an existing spaces name" do
      repo = SpaceRepository.new
      space = repo.find(1)
      space.price = 400
      repo.update_price(space)
      expect(space.price).to eq 400
    end

    it "adds no dates to the array" do
      repo = SpaceRepository.new
      space = repo.is_available?(1)
      expect(space.dates.length).to eq 0
    end

    it "adds dates to the array" do
      repo = SpaceRepository.new
      space = repo.is_available?(2)
      expect(space.dates.length).to eq 1
      expect(space.dates[0]).to eq "2023-11-06"
    end
  end
end
