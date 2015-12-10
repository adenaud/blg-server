class AlertsController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def index
  render nothing: true
  end

  def create

    uuid = SecureRandom.uuid
    content = request.body.read
    json = JSON.parse content
    json['uuid'] = uuid;
    Alert.create(json)
    render json: { :status => 0, :uuid => uuid }
  end

  def update
    content = request.body.read
    json = JSON.parse content
    uuid = json['uuid']
    alert =  Alert.find_by(uuid: uuid)
    alert.update(json)

    render json: 0
  end
end
