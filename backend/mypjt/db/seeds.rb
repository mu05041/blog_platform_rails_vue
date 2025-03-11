# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb
categories = [
  'Travel', 
  'Food', 
  'Lifestyle', 
  'Technology', 
  'Sports', 
  'Music'
]
categories.each do |category_name|
  Category.find_or_create_by(name: category_name)
end

tags = [
  'Sunny',
  'Cloudy', 
  'Rainy',
  'Snowy',
  'Windy',
  'Stormy'
]
tags.each do |tag_name|
  Tag.create(name: tag_name)
end