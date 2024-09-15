class Users::SessionsController < Devise::SessionsController
  respond_to :json
  skip_forgery_protection only: [:create]

  def create
    user = User.find_for_authentication(email: params[:user][:email])
    
    if user&.valid_password?(params[:user][:password])
      sign_in(resource_name, user)
      cookies["CSRF-TOKEN"] = form_authenticity_token
      response.set_header('X-CSRF-Token', form_authenticity_token)
      render json: { message: 'You are logged in.' }, status: :created
    else
      render json: { message: 'Wrong email or password' }, status: :unauthorized
    end
  end

  def destroy
    if current_user
      sign_out(current_user)
      log_out_success
    else
      log_out_failure('No one is logged in.')
    end
  end

  private

  def respond_to_on_destroy
    if current_user
      log_out_success
    else
      log_out_failure
    end
  end

  def log_out_success
    render json: { message: 'You are logged out.' }, status: :ok
  end

  def log_out_failure
    render json: { message: 'Error: No one is logged in or there was a database issue.' }, status: :unauthorized
  end
end
