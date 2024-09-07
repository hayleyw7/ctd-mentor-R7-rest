class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  skip_forgery_protection only: [:create]

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      cookies["CSRF-TOKEN"] = form_authenticity_token
      response.set_header('X-CSRF-Token', form_authenticity_token)
      register_success && return
    end

    register_failed(resource)
  end

  def register_success
    render json: { message: 'Signed up successfully.' }, status: :created
  end

  def register_failed(resource)
    error_message = resource.errors.full_messages.uniq
    render json: { message: error_message }, status: :bad_request
  end
end
