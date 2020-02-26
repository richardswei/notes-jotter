# FactoryBot.define do
  
#   factory :note do
#     title {Faker::TvShows::BojackHorseman.character}
#     body {Faker::TvShows::BojackHorseman.tongue_twister}
#   end
#   factory :user do
#     email {'user-1@example.com'}
#     password {'password'}
#     notes { FactoryBot.create_list(:note, 15) }
#   end
#   factory :user2 do
#     email {'user-2@example.com'}
#     password {'password'}
#     notes { FactoryBot.create_list(:note, 15) }
#   end
  

# end

FactoryBot.define do

  # note factory
  factory :note do
    title {Faker::TvShows::BojackHorseman.character}
    body {Faker::TvShows::BojackHorseman.tongue_twister}
  end

  # user factory 
  factory :user do
    email {Faker::Internet.email}
    password {'password'}
  end
  
end