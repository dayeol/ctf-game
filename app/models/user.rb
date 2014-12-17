class User < ActiveRecord::Base
	has_many :solve
	has_many :penalty
	attr_accessible :name, :email, :password, :password_confirmation
	has_secure_password
	before_save {|user| user.email = email.downcase}
	before_save :create_remember_token
	validates :name, presence: true, length: {maximum: 50}
	validates :password, presence: true
	validates :password_confirmation, presence: true
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	#validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },uniqueness: { case_sensitive: false}
	validates :email, presence: true, uniqueness: { case_sensitive: false}

	def total_penalty
		self.penalty.sum( :percentage ).to_i
	end

	def score
		sum = 0
		self.solve.each do |s|
			if !s.problem.nil?
				sum += s.problem.point
			end
		end

		percent = 100 - self.penalty.sum( :percentage ).to_i



		return ( sum * (Float(Float(percent)/Float(100))) ).to_i
	end

	private
		def create_remember_token
			self.remember_token = SecureRandom.urlsafe_base64
		end

end
