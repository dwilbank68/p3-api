class Api::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :html, :json


  # curl http://localhost:3000/api/users
  def index
    users = User.all
    render json: users, each_serializer: UserSerializer2
  end




  # curl -d 'username=third&password=thirdpassword' http://localhost:3000/api/users/
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, :root => false, status: 201, location: @user # status: :created is the same thing
      # render nothing: true, status: 204, location: @user - which means empty response body, and is faster, or
      # head 204, location: @user - which means only the header, and is faster, or head :no_content, which is same thing
    else
      # render nothing: true, status: :missing_argument
      # render nothing: true, status: 500 # 422 would be better, since that means the error is on the client's side
      render json: @user.errors, status: 500 # status: 422 or status: :unprocessable_entity would be better, since that means the error is the client's
    end

  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.permit(:username, :password)
  end

end