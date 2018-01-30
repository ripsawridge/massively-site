require 'fileutils'
require 'pathname'

module Jekyll
  class CreateMapData < Jekyll::Generator

    def addTrip(location_trips, key, trip)
      a = location_trips[key]
      if a
        a.push(trip)
      else
        Jekyll.logger.warn "CreateMapData", 
          "Trip location " + key + 
          " not found in locations list"
        Jekyll.logger.warn "CreateMapData",
          "(referenced in file " + trip.path + ")"
      end
    end

    def generate(site)
      # Create a hash of locations mapping location name
      # (string) to a list of trips.

      locations = site.data["locations"]
      location_trips = {}
      locations.each do |location|
        location_trips[location["name"]] = []
      end

      trips = site.collections["cma"].docs
      trips.each do |trip|
        trip_locations = trip.data["location"]
        if trip_locations.is_a?(Array)
          trip_locations.each do |trip_location|
            addTrip(location_trips, trip_location, trip)
          end
        elsif trip_locations
          addTrip(location_trips, trip_locations, trip)
        else
          Jekyll.logger.warn "CreateMapData", 
            "empty location in " + 
            trip.path  # .data  # ["title"]
        end
      end
    end
  end
end

