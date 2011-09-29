class CountriesController < ApplicationController
  layout "admin"
  before_filter :require_admin_user

  def index
    @countries = Country.all

    @unknown = []
    ShippingPlan.find(:all, :select => 'DISTINCT country').each do |shipping_plan|
      if Country.find_by_iso3(shipping_plan.country).nil?
        @unknown << shipping_plan if @unknown.select{|x| x.country == shipping_plan.country }.size == 0
      end
    end

  end

  def new
    @country = Country.new
  end

  def edit
    @country = Country.find_by_id params[:id]
  end

  def create
    @country = Country.create params[:country]
    if @country.save
      redirect_to countries_path
    else
      render :new
    end
  end

  def update
    @country = Country.find_by_id params[:id]
    if @country.update_attributes params[:country]
      redirect_to countries_path
    else
      render :edit
    end
  end

  def destroy
    @country = Country.find_by_id params[:id]
    @country.destroy
    redirect_to countries_path
  end

end
