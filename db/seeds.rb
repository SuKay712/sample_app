# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Generate a bunch of additional users.
User.create!(name:  "nguyenkhoi",
               email: "khoile712003@gmail.com",
               password:              "password",
               password_confirmation: "password",
               birthday:              "2003-12-07",
               admin:                 true,
               gender:                "Male")
100.times do |n|
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  birthday = "2012-11-1"
  gender = "Other"
  User.create!(name:  Faker::Name.name,
               email: email,
               password:              password,
               password_confirmation: password,
               birthday:              birthday,
               gender:                gender)
end
