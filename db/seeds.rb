User.create!(name:  "nguyenkhoi",
               email: "khoile712003@gmail.com",
               password:              "password",
               password_confirmation: "password",
               birthday:              "2003-12-07",
               admin:                 true,
               gender:                "Male")
50.times do |n|
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  birthday = "2012-11-1"
  gender = "Other"
  User.create!(name:  Faker::Name.name,
               email: email,
               password:              password,
               password_confirmation: password,
               birthday:              birthday,
               gender:                gender,
               admin: false)
end
