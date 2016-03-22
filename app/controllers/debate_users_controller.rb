#not sure about this modeling yet
class DebateUsersController < ApplicationController

  before_filter :find_debate
  def new
    @debate_user = DebateUser.new
  end

  def create
    @debate_user = @debate.debate_users.build(debate_user_params)
  end

  private
  def find_debate
    @debate = Debate.find(params[:id])
  end

  def debate_user_params
    params.require(:debate_user).permit(:position_description)
  end
end
