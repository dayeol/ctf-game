class Problem < ActiveRecord::Base
	has_many :solve
	attr_accessible :category, :hint, :key, :name, :point, :file, :maker
	mount_uploader :file, FileUploader
end
