class ImagesController < ApplicationController
  protect_from_forgery except: :create
  before_action :authenticate_user!

  def create
    @image = Image.new(image_params)
    @image.save
    respond_to do |format|
      format.json { render :json => { url: @image.image.url, image_id: @image.id } }
    end
  end

  def destroy
    @image = Image.find(params[:id])
    @image.destroy
    respond_to do |format|
      format.json { render :json => { status: :ok } }
    end
  end

  private
  def image_params
    params.require(:image).permit(:image, :image_file_name, :image_content_type, :image_file_size, :image_updated_at)
  end
end
