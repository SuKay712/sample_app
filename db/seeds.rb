# User.create!(name:  "nguyenkhoi",
#                email: "khoile712003@gmail.com",
#                password:              "password",
#                password_confirmation: "password",
#                birthday:              "2003-12-07",
#                admin:                 true,
#                gender:                "Male",
#                activated: true)
users = User.order(:created_at).take(6)

50.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(content: content) }
end
# 10.times do |n|
#   email = "example-#{n+1}@railstutorial.org"
#   password = "password"
#   birthday = "2012-11-1"
#   gender = "Other"
#   User.create!(name:  "Khoi#{n+1}",
#                email: email,
#                password:              password,
#                password_confirmation: password,
#                birthday:              birthday,
#                gender:                gender,
#                admin: false,
#                activated: true)
# end
