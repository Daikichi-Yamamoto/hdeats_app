module SessionsHelper

  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
    # セッションリプレイ攻撃から保護する
    session[:session_token] = user.session_token
  end

  # ユーザーを永続的セッションに保存する
  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user
    # セッションからユーザーを確認
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    # セッションがない場合、クッキーから確認
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
    # ユーザーが存在し、remember_tokenが一致すればログイン
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # 渡されたユーザーがカレントユーザーであればtrueを返す
  def current_user?(user)
    user && user == current_user
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

  # アクセスしようとしたURLを保存する
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end