require 'faker'

# Clear existing data
User.destroy_all
Film.destroy_all
Payment.destroy_all
# Rental.destroy_all

puts "Seeding Users..."
10.times do
  User.create!(
    name: Faker::Name.name,
    active: [true, false].sample,
    updated_at: Time.current
  )
end

puts "Seeding Films..."
categories = ["Action", "Comedy", "Drama", "Horror", "Sci-Fi"]
languages = ["English", "Spanish", "French", "German", "Japanese"]

10.times do
  Film.create!(
    title: Faker::Movie.title,
    release_year: rand(1990..2023),
    language: languages.sample,
    category: categories.sample,
    rental_price: rand(5.0..20.0).round(2)
  )
end

puts "Seeding Payments..."
users = User.all
films = Film.all

15.times do
  Payment.create!(
    user: users.sample,
    film: films.sample,
    amount: rand(10.0..50.0).round(2),
    payment_date: Faker::Time.backward(days: 30)
  )
end

puts "Seeding Rentals..."
10.times do
  Rental.create!(
    user: users.sample,
    film: films.sample,
    rental_date: Faker::Time.backward(days: 20),
    return_date: [nil, Faker::Time.backward(days: 5)].sample
  )
end

puts "✅ Seeding completed!"
