class ThemePagesController < ApplicationController
  layout 'admin'
  before_filter :require_admin_user
  def new
    @theme = Theme.find_by_id params[:theme_id]
    @theme_page = @theme.theme_pages.build
  end

  def edit
    @theme = Theme.find_by_id params[:theme_id]
    @theme_page = @theme.theme_pages.find_by_id params[:id]
  end

  def create
    @theme = Theme.find_by_id params[:theme_id]
    @theme_page = @theme.theme_pages.build params[:theme_page]
    if @theme_page.save
      redirect_to edit_theme_theme_page_path(@theme, @theme_page)
    else
      render :edit
    end
  end

  def update
    @theme = Theme.find_by_id params[:theme_id]
    @theme_page = @theme.theme_pages.find_by_id params[:id]
    @updated = @theme_page.update_attributes params[:theme_page]
    respond_to do |format|
      format.html do
        if @updated
          redirect_to edit_theme_theme_page_path(@theme, @theme_page)
        else
          render :edit
        end
      end
      format.js
    end
  end

end
