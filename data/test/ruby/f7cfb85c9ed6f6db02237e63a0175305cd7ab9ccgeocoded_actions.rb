module GeocodedActions


  def copy_attributes_to(object)
    object.address = self.address
    object.latitude = self.latitude
    object.longitude = self.longitude
    object.route = self.route
    object.neighborhood_name = self.neighborhood_name
    object.city_name = self.city_name
    object.state_name = self.state_name
    object.state_code = self.state_code
    object.country_name = self.country_name
    object.country_code = self.country_code
    object.postal_code = self.postal_code
    object.street_number = self.street_number
    object.full_address = self.full_address
    object.formatted_address = self.formatted_address

    object.save
  end


  def neighborhood
    Neighborhood.find_by(name: neighborhood_name)
  end


  def city
    City.find_by(name: city_name)
  end

  def city=(city)
    self.city_name = city.try(:name)
  end


  def state
    State.find_by(name: state_name)
  end


  def country
    Country.find_by(name: country_name)
  end

  def localize_from_ip
    if request.remote_ip == '127.0.0.1'
      # Hard coded remote address
      '123.45.67.89'
    else
      Geocoder.search("#{request.remote_ip}").first.coordinates
    end
  end

  def coordinates
    [latitude, longitude]
  end



  def distance_until(event, format = :km)

    if has_geocoded?(event)
      distance = calculate_distance(event)

      case format
      when :km then distance_to_km(distance)
      when :minutes then calculate_distances_for_transport(distance)
      end
    end

  end


  KM_HOUR_BUS = 35
  KM_HOUR_CAR = 40
  KM_HOUR_WALK = 4.5
  KM_HOUR_BIKE = 20



  def calculate_distances_for_transport(distance)
    {
      bus: calculate_distance_for_bus(distance),
      car: calculate_distance_for_car(distance),
      walk: calculate_distance_for_walk(distance),
      bike: calculate_distance_for_bike(distance)
    }
  end

  def calculate_distance_for_bike(distance)
    (distance_in_minutes_calculate(distance, KM_HOUR_BIKE) + (distance / 100 * 10)).round.to_s
  end

  def calculate_distance_for_walk(distance)
    result = (distance_in_minutes_calculate(distance, KM_HOUR_WALK) + (distance / 100 * 5)).round
    if result > 60
      "#{(result.to_f / 60.to_f).round(2)}h"
    else
      "#{result}min"
    end
  end

  def calculate_distance_for_car(distance)
    (distance_in_minutes_calculate(distance, KM_HOUR_CAR) + (error_margin_calculate(distance, 10)) + stand_by_time(3)).round.to_s
  end

  def calculate_distance_for_bus(distance)
    (distance_in_minutes_calculate(distance, KM_HOUR_BUS) + (error_margin_calculate(distance, 30)) + stand_by_time(10)).round.to_s
  end

  def distance_in_minutes_calculate(distance, transport)
    (distance / transport * 60)
  end

  def stand_by_time(time)
    (time).round(3)
  end

  def error_margin_calculate(distance, margin)
    to_percentage(distance, margin)
  end

  def to_percentage(distance, margin)
    (distance / 100) * margin
  end


  def distance_to_km(distance)
    distance.to_s << "km"
  end


  def calculate_distance(event)
    distance = Geocoder::Calculations.distance_between([self.latitude, self.longitude], [event.latitude, event.longitude], {units: :km}).round(3)
    margem = distance.round(3) / 100 * 33
    (distance + margem).round(3)
  end


  def has_geocoded?(event)
    unless event.latitude.blank? and event.longitude.blank?
      true
    end
  end


end