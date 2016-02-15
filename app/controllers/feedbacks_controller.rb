class FeedbacksController < ApplicationController
  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(feedback_params)
    if @feedback.save!
      flash[:success] = true
      flash[:message] = "Thank you for your feedback!"
      redirect_to '/'
    else
      flash[:success] = false
      flash[:message] = "Could not submit feedback!"
    end
  end

  private
  def feedback_params
    params.require(:feedback).permit(:name, :feedback_content)
  end
end
