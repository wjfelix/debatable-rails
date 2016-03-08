class InvitesController < ApplicationController

  def update
    @invite = Invite.find(params[:id])
    @invite.update!(invite_params)
  end

  private
  def invite_params
    params.require(:invite).permit(:is_seen)
  end
end
