module Api
  module V1
    class SeedsController < ActionController::Base
      def create
        @vegetable_process = VegetableProcess.find(params[:vegetable_process_id])
        @today = Date.today
        @term_date = @today + @vegetable_process.maturation_length
        @seed = Seed.create(user_id: current_user.id,
                            vegetable_process_id: params[:vegetable_process_id],
                            name: @vegetable_process.name,
                            planting_date: @today,
                            term_date: @term_date,
                            )
        render :show
      end
    end
  end
end
