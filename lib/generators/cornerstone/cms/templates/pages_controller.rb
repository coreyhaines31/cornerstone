class PagesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_page, only: [:show, :edit, :update, :destroy]
  before_action :authorize_page, except: [:index, :show, :new, :create]

  def index
    @pages = policy_scope(Page).order(created_at: :desc)
    authorize Page
  end

  def show
    if @page.nil? || (!@page.published? && !user_signed_in?)
      raise ActiveRecord::RecordNotFound
    end
  end

  def new
    @page = Page.new
    authorize @page
  end

  def create
    @page = Page.new(page_params)
    @page.author = current_user
    authorize @page

    if @page.save
      redirect_to @page, notice: 'Page was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @page
  end

  def update
    authorize @page
    if @page.update(page_params)
      redirect_to @page, notice: 'Page was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @page
    @page.destroy
    redirect_to pages_url, notice: 'Page was successfully deleted.'
  end

  private

  def set_page
    @page = Page.find_by(slug: params[:slug] || params[:id])
  end

  def authorize_page
    authorize @page
  end

  def page_params
    params.require(:page).permit(:title, :slug, :content, :meta_description, :published_at)
  end
end