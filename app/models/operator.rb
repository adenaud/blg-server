class Operator < ActiveRecord::Base
  self.primary_key = 'id'
  has_many :alerts
end