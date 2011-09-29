class ThemesController < ApplicationController
  layout 'admin'
  before_filter :require_admin_user


  def show
    @theme = Theme.find_by_id params[:id]
  end

  def index
    @themes = Theme.order('position')
  end

  def new
    @theme = Theme.new
  end

  def create
    @theme = Theme.new params[:theme]
    @theme.save
    redirect_to themes_path
  end

  def edit
    @theme = Theme.find_by_id params[:id]
  end

  def update
    @theme = Theme.find_by_id params[:id]
    @theme.update_attributes params[:theme]
    redirect_to themes_path
  end

  def destroy
    @theme = Theme.find_by_id params[:id]
    @theme.destroy
    redirect_to themes_path
  end

  def sort
    Theme.all.each do |theme|
      if position = params[:themes].index(theme.id.to_s)
        theme.update_attribute(:position, position + 1) unless theme.position == position + 1
      end
    end
    render :nothing => true, :status => 200
  end

end
