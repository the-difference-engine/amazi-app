class Location < ApplicationRecord
  belongs_to :location_subcategory
  belongs_to :water_provider
  has_many :saved_locations
  has_many :problems
  has_many :images
  has_many :location_water_types
  has_many :water_types, through: :location_water_types

  geocoded_by :full_street_address   # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates



  def full_street_address
    return "#{address}, #{city}, #{state}"
  end

  def get_google_places_id(names)
    client = GooglePlaces::Client.new(ENV['GOOGLE_PLACES_API_KEY'])
    names.split(" ").each do |name|
      c = client.spots(latitude, longitude, :formatted_address => full_street_address, :radius => 1, :name => name)
      if c
        return c.first.instance_variable_get(:@place_id)
      end
    end
    return false
  end

end



