class AlertsController < ApplicationController

  skip_before_filter :verify_authenticity_token
  before_filter :set_headers

  API_KEY = 'AIzaSyB7EiKHACFZOdNIV8SPcWjkccjdLUdcXXk'
  GEOCODING_API_URL = 'https://maps.googleapis.com/maps/api/geocode/json?'

  def index
    render plain: Alert.all.to_json(:include => [:user, :operator])
  end

  def create
    uuid = SecureRandom.uuid
    content = request.body.read
    json = JSON.parse content
    user = User.find_by(uuid: json['user_uuid'])
    json['user_id'] = user.id
    json['uuid'] = uuid
    json['time'] = DateTime.now
    lat = json['latitude']
    lng = json['longitude']
    json['address'] = reverse_geocode(lat, lng)
    Alert.create(json)
    render json: { :status => 0, :uuid => uuid }
  end

  def update
    content = request.body.read
    json = JSON.parse content
    uuid = json['uuid']
    alert =  Alert.find_by(uuid: uuid)
    alert.update(json)
    result = Hash.new
    result['status'] = 0
    render json: result
  end

  def options
    render plain: 'ok'
  end

  private

  def set_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Expose-Headers'] = 'ETag'
    headers['Access-Control-Allow-Methods'] = 'GET, POST, PATCH, PUT, DELETE, OPTIONS, HEAD'
    headers['Access-Control-Allow-Headers'] = '*,x-requested-with,Content-Type,If-Modified-Since,If-None-Match'
    headers['Access-Control-Max-Age'] = '86400'
  end

  def reverse_geocode(lat, lng)
    api_url = URI.parse "#{GEOCODING_API_URL}latlng=#{lat},#{lng}&key=#{API_KEY}"
    http =  Net::HTTP.new(api_url.host, api_url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    geocode_json = JSON.parse http.get(api_url.request_uri).body

    unless geocode_json['results'].count == 0
      geocode_json['results'][0]['formatted_address']
    end
  end
end
