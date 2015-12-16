class Alert < ActiveRecord::Base
  self.primary_key = 'id'
  belongs_to :user, foreign_key: 'user_id'
  belongs_to :operator, foreign_key: 'operator_id'
end