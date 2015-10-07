class User < ActiveRecord::Base

	has_many :relationships, dependent: :destroy
	has_many :inverse_relationships, class_name: "Relationship", foreign_key: "match_id", dependent: :destroy

	has_attached_file :avatar,
					  :storage => :s3,
					  :style => {:medium => "370x370", :thumb => "100x100"}
	validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

	default_scope { order('id DESC') }


	def self.sign_in_from_facebook(auth)
		find_by(provider: auth['provider'], uid: auth['uid']) || create_user_from_facebook(auth)
	end

	def self.create_user_from_facebook(auth)
		create(

			avatar: process_uri(auth['info']['image'] + "?width=9999"),
			email: auth['info']['email'],
			provider: auth['provider'],
			uid: auth['uid'],
			name: auth['info']['name'],
			gender: auth['extra']['raw_info']['gender'],
			date_of_birth: auth['extra']['raw_info']['birthday'],
			location: auth['info']['location'],
			bio: auth['extra']['raw_info']['bio']

			)
	end

	#Relationship Models
	def request_match(user2)
		self.relationships.create(match: user2)
	end

	def accept_match(user2)
		self.relationships.where(match: user2).first.update_attribute(:state, "Active")
	end

	def remove_match(user2)
		inverse_relationship = inverse_relationships.where(user_id: user2).first
		if inverse_relationship
			self.inverse_relationships.where(user_id: user2).first.destroy
		else
			self.relationships.where(match_id: user2).first.destroy
		end
	end
	#Relationship Models	

	# Filter Methods
	def self.gender(user)
		case user.interest
			when "Male"
			where('gender = ?', 'male')
			when "Female"
			where('gender = ?', 'female')
			else
			all
		end
	end

	def self.not_me(user)
		where.not(id: user.id)
	end

	def matched_likes(current_user)
		relationships.where(state: "pending").map(&:match) + current_user.relationships.where(state: "Active").map(&:match) + current_user.inverse_relationships.where(state: "Active").map(&:user)
	end
	# Filter Methods


	private

	def self.process_uri(uri)
		avatar_url = URI.parse(uri)
		avatar_url.scheme = 'https'
		avatar_url.to_s
	end
end
