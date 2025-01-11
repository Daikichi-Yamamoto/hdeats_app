module SessionsHelper
  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # 永続的セッションのためにユーザーをデータベースに記憶する
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 現在のユーザーを返す（セッションまたはクッキーから取得）
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id]) # signed cookie で user_id を取得
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token]) # remember_token を照合
        log_in user
        @current_user = user
      end
    end
  end

  # ユーザーがログインしていれば true、その他なら false を返す
  def logged_in?
    !current_user.nil?
  end

  # 永続的セッションを破棄する（クッキーから削除）
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    reset_session
    @current_user = nil   # 安全のため
  end
end