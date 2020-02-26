# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# generate 5 fake users
require 'faker'

User.create(email: "tester@example.com", password: "password", password_confirmation: "password")

4.times do |idx|
  User.create(email: Faker::TvShows::SiliconValley.email, password: "password", password_confirmation: "password")
end

User.all.each do |user|
  10.times do |idx|
    title = idx%2==0 ? Faker::TvShows::NewGirl.character : Faker::TvShows::TheFreshPrinceOfBelAir.character
    body = idx%2==0 ? Faker::TvShows::NewGirl.quote : Faker::TvShows::TheFreshPrinceOfBelAir.quote
    user.notes.create(
      title: title,
      body: body
    )
  end
end
