class User < ActiveRecord::Base
	has_attached_file :avatar,
					  :storage => :s3,
					  :styles => {:medium => "370x370", :thumbnail => "100x100"}

	def self.sign_in_from_facebook(auth)
		find_by(provider: auth['provider'], uid:['uid']) || create_user_from_facebook(auth)
	end

	def self.create_user_from_facebook(auth)
		create(

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
end
