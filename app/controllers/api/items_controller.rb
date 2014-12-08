class Api::ItemsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_item, only: [:show, :update, :destroy]
  before_action :set_list
  before_action :set_user

  # curl -i -X POST -d 'name=frog%20duties' http://localhost:3000/api/lists/6?password=fifthpassword
  def create
    #render json: params
    if params[:password] == @user.password
      item = @list.items.new(item_params)

      if item.save
        render json: item, :root => false, status: 201 # or status: :created
      else
        render json: item.errors, status: 500
      end
    else
      render nothing: true, status: 401
    end

  end



  # curl -i -X DELETE http://localhost:3000/api/lists/6/items/10?password=fifthpassword
  def destroy

    if params[:password] == @user.password
      if @item.destroy
        render json: '"item destroyed"', status: 204
      else
        render nothing: true, status: 500
      end
    else
      render nothing: true, status: 401
    end

  end



  private

  def set_user
    @user = @list.user
  end

  def set_item
    @item_exists = Item.where(id: params[:id]).exists?

    if @item_exists
      @item = Item.find(params[:id])
    else
      render nothing: true, status: 410
    end


  end

  def set_list
    @list = @item ? @item.list : List.find(params[:list_id])
  end

  def item_params
    params.permit(:description, :list_id, :completed)
  end
end
