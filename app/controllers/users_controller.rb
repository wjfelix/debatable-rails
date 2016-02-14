class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      UserMailer.email_validation(@user)
      flash[:success] = true
      flash[:message] = "Account successfully created! Check your E-mail for a verification link"
      redirect_to root_url
    else
      flash[:success] = false
      flash[:message] = "You have not completed the required fields!"
      redirect_to new_user_path
    end
  end

  def show
    @user = User.find(params[:id])
    @total = []
    @debates = @user.debates
    @firetalks = @user.firetalks
    @firetalk_debaters = FiretalkDebater.where(:user_id => @user.id)

    @posts = @user.posts
    @debates.each do |debate|
      @total.push(debate)
    end
    @firetalks.each do |firetalk|
      @total.push(firetalk)
    end
    @firetalk_debaters.each do |firetalk_debater|
      @total.push(firetalk_debater)
    end
    @posts.each do |post|
      @total.push(post)
    end
    @total.sort_by! { |model| model.created_at.to_date}
  end

  def edit
  end

  def update
  end

  def validate_email
    user = User.find_by_validation_code(params[:id])

    if user
      user.is_validated = true
      if user.save
        flash[:success] = true
        flash[:message] = "E-mail successfully verified, Thanks for registering!"
        redirect_to login_path
      else
        flash[:succes] = false
        flash[:message] = "There was an error verifying your account!"
        redirect_to root
      end
    else
      flash[:success] = false
      flash[:message] = "Sorry, that user does not exist!"
      redirect_to login_path
    end
  end

  private
  def user_params
    params.require(:user).permit(:firstname, :lastname, :email, :password, :password_confirmation)
  end
end
