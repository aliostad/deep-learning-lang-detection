module Api
  module V1
    class VegetableProcessesController < ActionController::Base
      def index
        @vegetable_processes = VegetableProcess.all
        render :index
      end
      def show
        @vegetable_process = VegetableProcess.find(params[:id])
        render :show
      end

      def identify_star_and_destroy
        @vegetable_process = VegetableProcess.find(params[:vegetable_process_id])
        @star = Star.where(vegetable_process_id: @vegetable_process,
                           stared_by: current_user).first
        @star.destroy
        @vegetable_process
        render '/api/v1/vegetable_processes/show'
      end
    end
  end
end
