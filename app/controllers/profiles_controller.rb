class ProfilesController < ApplicationController
  skip_before_filter :verify_authenticity_token

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
end
