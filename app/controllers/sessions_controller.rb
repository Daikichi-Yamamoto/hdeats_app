class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      forwarding_url = session[:forwarding_url]
      reset_session
      log_in user  # ログイン処理を先に行う
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to forwarding_url || user
    else
      flash.now[:danger] = 'メールアドレスとパスワードの組み合わせが無効です'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end
end
