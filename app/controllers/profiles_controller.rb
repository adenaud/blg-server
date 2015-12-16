class ProfilesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :set_headers

  def show
    user_uuid = params['id']
    render json: User.find_by(uuid: user_uuid)
  end

  def create
    uuid = SecureRandom.uuid
    content = request.body.read
    json = JSON.parse content

    md5 = Digest::MD5.new
    password = json['password']
    md5.update password
    json['password'] = md5.hexdigest
    json['uuid'] = uuid
    User.create(json)
    render json: {:status => 0, :uuid => uuid}
  end

  def update
    content = request.body.read
    json = JSON.parse content

    md5 = Digest::MD5.new
    password = json['password']
    md5.update password
    json['password'] = md5.hexdigest
    uuid = json['uuid']
    profile = User.find_by(uuid: uuid)
    profile.update(json)
    result = Hash.new
    result['status'] = 0
    render json: result
  end

  def login
    content = request.body.read
    json = JSON.parse content
    md5 = Digest::MD5.new

    identifier = json['identifier']
    password = json['password']
    md5.update password
    hashed_password = md5.hexdigest

    count = User.where(email: identifier).count

    result = Hash.new
    if count == 1
      user = User.find_by(email: identifier)
      if user.password.eql? hashed_password
        result['status'] = 0
        result['message'] = 'LOGIN_OK'
        result['uuid'] = user.uuid
      else
        result['status'] = 1
        result['message'] = 'INVALID_PASSWORD'
      end
    else
      result['status'] = 2
      result['message'] = 'INVALID_EMAIL'
    end
    render json: result
  end

  def set_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Expose-Headers'] = 'ETag'
    headers['Access-Control-Allow-Methods'] = 'GET, POST, PATCH, PUT, DELETE, OPTIONS, HEAD'
    headers['Access-Control-Allow-Headers'] = '*,x-requested-with,Content-Type,If-Modified-Since,If-None-Match'
    headers['Access-Control-Max-Age'] = '86400'
  end
end
