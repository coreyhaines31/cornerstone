class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy, :switch]

  def index
    @accounts = current_user.accounts.order(:name)
    authorize Account
  end

  def show
    authorize @account
  end

  def new
    @account = Account.new
    authorize @account
  end

  def create
    @account = Account.new(account_params)
    authorize @account

    if @account.save
      # Create membership for current user as owner
      @account.memberships.create!(
        user: current_user,
        role: 'owner',
        accepted_at: Time.current
      )

      # Switch to new account
      session[:current_account_id] = @account.id

      redirect_to @account, notice: 'Account was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @account
  end

  def update
    authorize @account

    if @account.update(account_params)
      redirect_to @account, notice: 'Account was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @account

    if @account.memberships.where(role: 'owner').count == 1
      flash[:alert] = "Cannot delete account. You are the only owner. Please transfer ownership first."
      redirect_to @account
      return
    end

    @account.destroy
    redirect_to accounts_url, notice: 'Account was successfully deleted.'
  end

  def switch
    authorize @account, :switch?

    if switch_account(@account)
      respond_to do |format|
        format.html { redirect_to dashboard_path, notice: "Switched to #{@account.name}" }
        format.turbo_stream
      end
    else
      flash[:alert] = "Unable to switch to that account."
      redirect_to accounts_path
    end
  end

  def settings
    @account = current_account
    authorize @account, :update?
  end

  def update_settings
    @account = current_account
    authorize @account, :update?

    if @account.update(settings_params)
      redirect_to account_settings_path, notice: 'Settings updated successfully.'
    else
      render :settings, status: :unprocessable_entity
    end
  end

  private

  def set_account
    @account = current_user.accounts.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:name, :slug, :settings)
  end

  def settings_params
    params.require(:account).permit(:name, :slug, settings: {})
  end
end