# frozen_string_literal: true

class Space
  attr_accessor :id, :user_id, :name, :description, :price, :dates

   def initialize
      @dates = []
   end
end
