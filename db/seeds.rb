# Seeds for development environment
# Creates sample races for each city with varied statuses and distances
#
# Run with: bin/rails db:seed

puts "Seeding database..."

# Clear existing races (and their distances via cascade)
Race.destroy_all

# Image paths
images_dir = Rails.root.join("db/seeds/images")
image_files = {
  tijuana: images_dir.join("race_tijuana.jpg"),
  rosarito: images_dir.join("race_rosarito.jpg"),
  tecate: images_dir.join("race_tecate.jpg"),
  mexicali: images_dir.join("race_mexicali.jpg")
}

# Helper method to attach image
def attach_featured_image(race, image_path)
  return unless File.exist?(image_path)

  race.featured_image.attach(
    io: File.open(image_path),
    filename: File.basename(image_path),
    content_type: "image/jpeg"
  )
end

# Tijuana races (3 races)
tijuana_races = [
  {
    name: "Tijuana Marathon 2025",
    start_time: 4.weeks.from_now,
    location_description: "Starting at Parque Teniente Guerrero, finishing at Playas de Tijuana",
    location_address: "Calle 3ra y Av. Revolucion, Tijuana",
    city: :tijuana,
    status: :published,
    cost: 75.00,
    registration_url: "https://tijuanamarathon.com/register",
    registration_info: "Early bird registration ends 2 weeks before race day",
    day_of_race_registration: false,
    organizer_name: "Tijuana Athletics Association",
    organizer_contact: "info@tijuanaathletics.org",
    distances: [
      { distance_value: 5.0, distance_unit: :km },
      { distance_value: 10.0, distance_unit: :km },
      { distance_value: 21.0, distance_unit: :km },
      { distance_value: 42.2, distance_unit: :km }
    ]
  },
  {
    name: "Tijuana City Run",
    start_time: 6.weeks.from_now,
    location_description: "Downtown Tijuana, scenic city tour route",
    location_address: "Zona Centro, Tijuana",
    city: :tijuana,
    status: :published,
    cost: 25.00,
    day_of_race_registration: true,
    notes: "Family-friendly event with kids' zone",
    distances: [
      { distance_value: 5.0, distance_unit: :km }
    ]
  },
  {
    name: "Tijuana Night Run (Draft)",
    start_time: 8.weeks.from_now,
    location_description: "Evening run through illuminated city streets",
    city: :tijuana,
    status: :draft,
    cost: 35.00,
    notes: "Still finalizing route and permits",
    distances: [
      { distance_value: 10.0, distance_unit: :km }
    ]
  }
]

# Rosarito races (3 races)
rosarito_races = [
  {
    name: "Rosarito Beach Run",
    start_time: 3.weeks.from_now,
    location_description: "Beautiful oceanfront course along Rosarito Beach",
    location_address: "Blvd. Benito Juarez, Rosarito",
    city: :rosarito,
    status: :published,
    cost: 50.00,
    registration_url: "https://rosarito-running.mx/beach-run",
    day_of_race_registration: true,
    notes: "Flat course - perfect for PRs!",
    distances: [
      { distance_value: 5.0, distance_unit: :km },
      { distance_value: 10.0, distance_unit: :km },
      { distance_value: 21.0, distance_unit: :km }
    ]
  },
  {
    name: "Rosarito Sunset 5K",
    start_time: 5.weeks.from_now,
    location_description: "Evening beach run with stunning sunset views",
    location_address: "Rosarito Beach Hotel",
    city: :rosarito,
    status: :published,
    cost: 0.00,
    registration_info: "Free community event - donations welcome",
    day_of_race_registration: true,
    distances: [
      { distance_value: 5.0, distance_unit: :km }
    ]
  },
  {
    name: "Rosarito Wine Country Trail",
    start_time: 10.weeks.from_now,
    location_description: "Trail run through Valle de Guadalupe vineyards",
    city: :rosarito,
    status: :draft,
    cost: 65.00,
    notes: "Partnering with local wineries for post-race tasting",
    distances: [
      { distance_value: 15.0, distance_unit: :km }
    ]
  }
]

# Tecate races (2 races)
tecate_races = [
  {
    name: "Tecate Mountain Challenge",
    start_time: 7.weeks.from_now,
    location_description: "Challenging mountain trail with elevation gain",
    location_address: "Parque Miguel Hidalgo, Tecate",
    city: :tecate,
    status: :published,
    cost: 45.00,
    registration_url: "https://tecate-trail.com/register",
    notes: "Elevation gain: 1,500 feet. Bring hydration!",
    organizer_name: "Baja Trail Runners",
    organizer_contact: "trails@bajarunners.com",
    distances: [
      { distance_value: 10.0, distance_unit: :km },
      { distance_value: 25.0, distance_unit: :km }
    ]
  },
  {
    name: "Tecate Border Run",
    start_time: 9.weeks.from_now,
    location_description: "Historic route along the international border",
    city: :tecate,
    status: :published,
    cost: 30.00,
    day_of_race_registration: true,
    distances: [
      { distance_value: 10.0, distance_unit: :miles }
    ]
  }
]

# Mexicali races (3 races)
mexicali_races = [
  {
    name: "Mexicali Desert Dawn",
    start_time: 2.weeks.from_now,
    location_description: "Early morning run to beat the desert heat",
    location_address: "Bosque de la Ciudad, Mexicali",
    city: :mexicali,
    status: :published,
    cost: 35.00,
    registration_url: "https://mexicali-running.com/desert-dawn",
    notes: "Race starts at 5:30 AM - water stations every 2km",
    organizer_name: "Mexicali Running Club",
    organizer_contact: "info@mexicalirunning.com",
    distances: [
      { distance_value: 5.0, distance_unit: :km },
      { distance_value: 10.0, distance_unit: :km }
    ]
  },
  {
    name: "Mexicali Marathon",
    start_time: 12.weeks.from_now,
    location_description: "Annual city marathon through downtown Mexicali",
    location_address: "Centro Civico, Mexicali",
    city: :mexicali,
    status: :published,
    cost: 60.00,
    registration_info: "Pacers available for 4:00 and 5:00 finish times",
    day_of_race_registration: false,
    distances: [
      { distance_value: 10.0, distance_unit: :km },
      { distance_value: 21.0, distance_unit: :km },
      { distance_value: 42.2, distance_unit: :km }
    ]
  },
  {
    name: "Mexicali Heritage Run (Completed)",
    start_time: 2.weeks.ago,
    location_description: "Cultural tour of historic Mexicali",
    city: :mexicali,
    status: :completed,
    cost: 20.00,
    notes: "Great event! Over 300 participants",
    distances: [
      { distance_value: 5.0, distance_unit: :km }
    ]
  }
]

# Combine all races
all_races = tijuana_races + rosarito_races + tecate_races + mexicali_races

# Create races with distances
created_count = 0
distance_count = 0

all_races.each do |race_attrs|
  distances = race_attrs.delete(:distances)

  race = Race.new(race_attrs)

  # Build distances
  distances.each do |dist|
    race.race_distances.build(dist)
    distance_count += 1
  end

  # Attach image
  image_path = image_files[race.city.to_sym]
  attach_featured_image(race, image_path)

  # Set published_at for published races
  if race.published?
    race.published_at = rand(1..7).days.ago
  end

  if race.save
    created_count += 1
    puts "  Created: #{race.name} (#{race.city}, #{race.status}) with #{race.race_distances.count} distance(s)"
  else
    puts "  ERROR creating #{race.name}: #{race.errors.full_messages.join(', ')}"
  end
end

puts "\nSeeding complete!"
puts "  Races created: #{created_count}"
puts "  Race distances created: #{distance_count}"
puts "  Expected: 11 races, 22 distances"
