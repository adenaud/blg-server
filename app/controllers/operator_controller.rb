class OperatorController < ApplicationController

  skip_before_filter :verify_authenticity_token
  before_filter :set_headers

  def login


    json = JSON.parse request.body.read

    result = Hash.new
    login = json['username']
    password = json['password']
    md5 = Digest::MD5.new
    md5.update password
    hashed_password = md5.hexdigest
    count = Operator.where(login: login).count;
    if count == 1
      operator = Operator.find_by(login: login)
      if operator.password.eql? hashed_password
        result['status'] = 0
        result['message'] = 'LOGIN_OK'
      else
        result['status'] = 1
        result['message'] = 'INVALID_PASSWORD'
      end
    else
      result['status'] = 2
      result['message'] = 'INVALID_IDENTIFIER'
    end
    render json: result
  end

  private

  def set_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Expose-Headers'] = 'ETag'
    headers['Access-Control-Allow-Methods'] = 'GET, POST, PATCH, PUT, DELETE, OPTIONS, HEAD'
    headers['Access-Control-Allow-Headers'] = '*,x-requested-with,Content-Type,If-Modified-Since,If-None-Match'
    headers['Access-Control-Max-Age'] = '86400'
  end

end
