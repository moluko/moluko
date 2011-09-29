class ShippingPlansController < ApplicationController
  layout "admin"
  before_filter :require_user

  def index
    @shipping_plans = current_shop.shipping_plans.paginate :page => params[:page], :per_page => 30
  end

  def new
    redirect_to shipping_plans_path
    #@shipping_plan = current_shop.shipping_plans.build
  end

  def edit
    redirect_to shipping_plans_path
    #@shipping_plan = current_shop.shipping_plans.find_by_id params[:id]
  end

  def create
    #   @shipping_plan = current_shop.shipping_plans.build params[:shipping_plan]
    #   if @shipping_plan.save
    #     redirect_to shipping_plans_path
    #   else
    #     render :new
    #   end
  end

  def update
    #   @shipping_plan = current_shop.shipping_plans.find_by_id params[:id]
    #   if @shipping_plan.update_attributes params[:shipping_plan]
    #     redirect_to shipping_plans_path
    #   else
    #     render :edit
    #   end
  end

  def destroy
    @shipping_plan = current_shop.shipping_plans.find_by_id params[:id]
    @shipping_plan.destroy
    redirect_to shipping_plans_path
  end

  def create_using_csv
    if params[:csv].nil?
      flash[:error] = "CSV file required!"
    else
      file = params[:csv][:file]
      file_string = file.read
      #Delayed::Job.enqueue ImportShippingPlansUsingCSVJob.new(file_string, current_shop.id)
      ImportShippingPlansUsingCSVJob.new(file_string, current_shop).perform
      #flash[:info] = "Your shipping rates import request are being processed now. Please come back later."
    end
    redirect_to shipping_plans_path
  end

end
