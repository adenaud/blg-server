class ProfilesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :set_headers

  def show
    render nothing: true
  end

  def create
    uuid = SecureRandom.uuid
    content = request.body.read
    json = JSON.parse content
    json['uuid'] = uuid;
    User.create(json)
    render json: { :status => 0, :uuid => uuid }
  end

  def update
    content = request.body.read
    json = JSON.parse content
    uuid = json['uuid']
    profile =  User.find_by(uuid: uuid)
    profile.update(json)
    render json: 0
  end

  def set_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Expose-Headers'] = 'ETag'
    headers['Access-Control-Allow-Methods'] = 'GET, POST, PATCH, PUT, DELETE, OPTIONS, HEAD'
    headers['Access-Control-Allow-Headers'] = '*,x-requested-with,Content-Type,If-Modified-Since,If-None-Match'
    headers['Access-Control-Max-Age'] = '86400'
  end
end
