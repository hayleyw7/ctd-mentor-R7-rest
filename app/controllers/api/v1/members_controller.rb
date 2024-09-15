class Api::V1::MembersController < ApplicationController
  include AuthenticationCheck

  before_action :is_user_logged_in
  before_action :set_member, only: [:show, :update, :destroy]

  def index
    @members = Member.where(user_id: current_user.id)
    render json: { members: @members }
  end

  def show
    if check_access
      render json: @member
    else
      render json: { error: 'Access denied' }, status: 403
    end
  end

  def create
    @member = Member.new(member_params)
    @member.user_id = current_user.id
    if @member.save
      render json: @member, status: :created
    else
      render json: { error: "Unable to create member: #{@member.errors.full_messages.to_sentence}" }, status: :bad_request
    end
  end

  def update
    if check_access
      if @member.update(member_params)
        render json: @member
      else
        render json: { error: "Unable to update member: #{@member.errors.full_messages.to_sentence}" }, status: :bad_request
      end
    else
      render json: { error: 'Access denied' }, status: 403
    end
  end

  def destroy
    if check_access
      @member.facts.destroy_all
      @member.destroy
      render json: { message: 'Member record successfully deleted.' }, status: :ok
    else
      render json: { error: 'Access denied' }, status: 403
    end
  end

  private

  def set_member
    Rails.logger.debug("Finding member with ID: #{params[:id]}")
    @member = Member.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Member not found' }, status: :not_found
  end

  def member_params
    params.require(:member).permit(:first_name, :last_name)
  end

  def check_access
    @member.user_id == current_user.id
  end
end
