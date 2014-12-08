class Api::ListsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_user
  before_action :set_list, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json

  #curl -i -X GET http://localhost:3000/api/users/7/lists/6?password=fifthpassword
  def show
    if params[:password] == @user.password
      render json: @list.items
    else
      render nothing: true, status: 401
    end
  end

  def edit
  end

  #curl -i -X GET http://localhost:3000/api/users/7/lists?password=fifthpassword
  def index
    if params[:password] == @user.password
      lists = @user.lists
      render json: lists
    else
      render nothing: true, status: 401
    end
  end

  # curl -i -X POST -d 'name=frog%20duties' http://localhost:3000/api/users/7/lists?password=fifthpassword
  def create
    if params[:password] == @user.password
      list = List.new(list_params)
      list.user_id = @user.id

      if list.save
        render json: list, :root => false, status: 201, location: api_user_list_url(@user, list) # or status: :created
      else
        render list.errors, status: 500
      end
    else
      render nothing: true, status: 401
    end

  end

  #curl -i -X PUT -d 'name=froggy%20duties' http://localhost:3000/api/users/7/lists/7?password=fifthpassword
  def update
    if params[:password] == @user.password
      if @list.update(list_params)
        render json: @list, :root => false, status: 201, location: api_user_list_url(@user, @list)
      else
        render list.errors, status: 500
      end
    else
      render nothing: true, status: 401
    end
  end


  # curl -i -X DELETE http://localhost:3000/api/users/7/lists/10?password=fifthpassword
  def destroy
    # render json: params
    if params[:password] == @user.password
      @list.destroy
      head 204
    else
      render nothing: true, status: 401
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_list
    @list = List.find(params[:id])
  end

  def list_params
    params.permit(:name)
  end

end