class FiretalkDebatersController < ApplicationController
  protect_from_forgery with: :null_session

  def destroy
    binding.pry
    @firetalk_debaters = FiretalkDebater.where(:email => params[:email], :firetalk_id => params[:firetalk_id])
    @firetalk_debaters[0].destroy!
  end
end
