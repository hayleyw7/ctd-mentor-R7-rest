class Api::V1::FactsController < ApplicationController
  def index
    @member = Member.find(params[:member_id])
    @facts = @member.facts
    render json: @facts
  end

  def show
    @fact = Fact.find_by(member_id: params[:member_id], id: params[:id])
    if @fact
      render json: @fact
    else
      render json: { error: 'Fact not found' }, status: :not_found
    end
  end

  def create
    @member = Member.find(params[:member_id])
    @fact = @member.facts.new(fact_params)
    if @fact.save
      render json: @fact, status: :created
    else
      render json: @fact.errors, status: :unprocessable_entity
    end
  end

  def update
    @fact = Fact.find(params[:id])
    if @fact.update(fact_params)
      render json: @fact
    else
      render json: @fact.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @fact = Fact.find_by(member_id: params[:member_id], id: params[:id])
    if @fact
      @fact.destroy
      render json: { message: 'Fact deleted successfully' }, status: :ok
    else
      render json: { error: 'Fact not found' }, status: :not_found
    end
  end

  private

  def fact_params
    params.require(:fact).permit(:fact_text, :likes)
  end
end
