class Api::V1::GroupsController < ApplicationController
  before_action :authenticate_request
  attr_reader :current_user

  def create
    if current_user && current_user.admin?
      @group = Group.create(group_params)
       if @group.save
        response = { message: 'Group created successfully', group: @group.attributes}
        render json: response , status: :created
       else
        render json: @group.errors, status: :bad_request
       end
    else
      render json: {
          message: "Not Authorized"
        }, status: :unauthorized
    end
  end

  def user_groups
  end

  private

  def authenticate_request
    @current_user = Authorization.new(request).current_user
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  rescue => e
    render json: {
      message: e.message
    }, status: :unauthorized
  end

  def group_params
    params.permit(:name, :description)
  end
end
