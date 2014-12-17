class Penalty < ActiveRecord::Base
  attr_accessible :user_id, :giver_id, :percentage
  belongs_to :user
end
