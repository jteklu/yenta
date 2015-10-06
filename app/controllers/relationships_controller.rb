class RelationshipsController < ApplicationController
	before_action :require_login
	before_action :set_match

	def create
		@inverse_relationship = current_user.inverse_relationships.where(user_id: @match.id)
		
		unless @inverse_relationship.blank?
			@match.accept_match(current_user)
			@liked = true
		else
			current_user.request_match(@match)
		end

		respond_to do |format|
			format.js
		end

	end

	def destroy
		current_user.remove_match(@match)

		respond_to do |format|
			format.html { redirect_to users_path }
		end
	end


	private

	def set_match
		@match = User.find(params[:match_id])
	end

end
