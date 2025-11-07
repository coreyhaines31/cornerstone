class AccountMailer < ApplicationMailer
  def invitation(membership)
    @membership = membership
    @account = membership.account
    @inviter = membership.invited_by

    if membership.user
      @accept_url = accept_invitation_url(token: membership.invitation_token)
      mail(to: membership.user.email, subject: "You've been invited to #{@account.name}")
    else
      @signup_url = new_user_registration_url(invitation_token: membership.invitation_token)
      mail(to: membership.email, subject: "You've been invited to #{@account.name}")
    end
  end

  def member_invitation(membership)
    @membership = membership
    @account = membership.account
    @inviter = membership.invited_by
    @accept_url = accept_invitation_url(token: membership.invitation_token)

    mail(to: membership.user.email, subject: "You've been invited to #{@account.name}")
  end

  def member_joined(membership)
    @membership = membership
    @account = membership.account
    @new_member = membership.user

    mail(to: @account.owner.email, subject: "#{@new_member.name} joined #{@account.name}")
  end

  def invitation_declined(membership)
    @membership = membership
    @account = membership.account

    if membership.invited_by
      mail(to: membership.invited_by.email, subject: "Invitation declined")
    end
  end

  def subscription_created(account)
    @account = account
    mail(to: account.owner.email, subject: "Your subscription is active!")
  end

  def subscription_canceled(account)
    @account = account
    @end_date = account.subscription&.current_period_end

    mail(to: account.owner.email, subject: "Your subscription has been canceled")
  end

  def payment_received(account, invoice)
    @account = account
    @invoice = invoice
    @amount = (invoice.amount_paid / 100.0)

    mail(to: account.owner.email, subject: "Payment received - #{@amount}")
  end

  def payment_failed(account, invoice)
    @account = account
    @invoice = invoice
    @amount = (invoice.amount_due / 100.0)

    mail(to: account.owner.email, subject: "Payment failed")
  end

  def trial_ending(account)
    @account = account
    @days_left = (account.subscription.trial_end.to_date - Date.today).to_i

    mail(to: account.owner.email, subject: "Your trial ends in #{@days_left} days")
  end

  def checkout_completed(account)
    @account = account
    mail(to: account.owner.email, subject: "Welcome to #{Rails.application.config.application_name}!")
  end
end