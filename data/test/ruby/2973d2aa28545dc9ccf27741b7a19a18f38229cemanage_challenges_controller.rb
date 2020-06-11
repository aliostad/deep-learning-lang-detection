class ManageChallengesController < ApplicationController
	before_action :sign_in?
	# When user join a challenge, this controller save the challenge for future post related to challenge

	# Save a challenge for later usage when people join that challenge
	def create
		@manage_challenge = current_user.manage_challenges.build(create_manage_challenge)
		if @manage_challenge.save
			set_challenge = SetChallenge.find(create_manage_challenge)
			creat_or_update_potential_rel(set_challenge.user_id, current_user.id, 0, 0, 1)
			flash.now[:success] = "Hura! Post your achievement anytime at homepage :)"
		else 
			flash.now[:warning] = "You've already join this challenge!"
		end
	end

	# Unjoin challenge
	def destroy
		@manage_challenge = current_user.manage_challenges.find(params[:manage_challenge_id])
		if @manage_challenge.destroy
			flash[:success] = "Any other challenge do you want to join?"
		else
			flash[:error] = "Couldn't delete challenge"
		end
		@get_manage_challenge = current_user.manage_challenges.includes(:set_challenge)
	end

	private
		def create_manage_challenge
			params.permit(:set_challenge_id)
		end
end
