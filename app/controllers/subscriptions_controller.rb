class SubscriptionsController < ApplicationController

  before_action :find_subscription, only: :destroy

  def create
    authorize(@subscription = Subscription.create(user_id: params[:user_id], question_id: params[:question_id]))
    redirect_back(fallback_location: root_path)
  end

  def destroy
    authorize @subscription
    @subscription.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def find_subscription
    @subscription = Subscription.find(params[:id])
  end

end
