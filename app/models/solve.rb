class Solve < ActiveRecord::Base
	belongs_to :user
	belongs_to :problem
	attr_accessible :problem_id, :user_id
end
