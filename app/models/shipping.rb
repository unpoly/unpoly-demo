class Shipping < ActiveType::Object
  attribute :weight, :integer
  attribute :country, :string
  attribute :continent, :string

  validates :weight, presence: true
  validates :country, presence: true
  validates :continent, presence: true

  has_defaults continent: 'Europe', country: 'Austria', weight: 10

  before_validation :clear_invalid_country

  def assignable_countries
    if continent.present?
      countries = ISO3166::Country.find_all_countries_by_continent(continent)
      countries.map(&:common_name).sort
    else
      []
    end
  end

  def assignable_continents
    ISO3166::Country.all.map(&:continent).uniq.sort
  end

  def estimate
    if valid?
      Estimate.new(self)
    end
  end

  def sender_country
    'Germany'
  end

  def sender_continent
    'Europe'
  end

  def distance
    sender_coords = [sender_country_details.latitude, sender_country_details.longitude]
    receiver_coords = [country_details.latitude, country_details.longitude]
    distance = Haversine.distance(*sender_coords, *receiver_coords)
    [distance.to_kilometers, 500].min
  end

  private

  def clear_invalid_country
    if country.present? && assignable_countries.exclude?(country)
      self.country = nil
    end
  end

  def country_details
    if country.present?
      ISO3166::Country.find_country_by_common_name(country)
    end
  end

  def sender_country_details
    ISO3166::Country.find_country_by_common_name(sender_country)
  end

end
