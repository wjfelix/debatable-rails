class FiretalksController < ApplicationController
  def new
    @user = User.find(params[:user_id])
    @firetalk = Firetalk.new
  end

  def create
    @user = User.find(params[:user_id])
    @firetalk = @user.firetalks.build(firetalk_params)
    params[:firetalk_debaters].each do |email|
      @firetalk_debater = @firetalk.firetalk_debaters.build(email)
    end
    if @firetalk.save
      flash[:success] = true
      flash[:message] = "Successfully created new Firetalk!"
      redirect_to show_firetalk_path(@firetalk)
    else
      flash[:success] = false
      flash[:message] = "Failed to create Firetalk"
      redirect_to new_user_firetalk_path
    end
  end

  def show
    @firetalk = Firetalk.find(params[:id])

  end

  def join
  end

  private
  def firetalk_params
    params.require(:firetalk).permit(:topic, :name, :description, :rounds, :seconds,
                                      :firetalk_debaters_attributes => [:email])
  end
end
