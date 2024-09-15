class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  skip_forgery_protection only: [:create]

  def create
    build_resource(sign_up_params)

    resource.save
    if resource.persisted?
      if resource.active_for_authentication?
        sign_up(resource_name, resource)
        render json: { message: 'You are signed up.' }, status: :created
      else
        expire_data_after_sign_in!
        render json: { message: 'Signed up, but not active.' }, status: :ok
      end
    else
      clean_up_passwords(resource)
      set_minimum_password_length
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
