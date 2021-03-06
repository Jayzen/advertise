class DeviceAttachesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_device
  before_action :set_device_attach, only: [:show, :edit, :update, :destroy, :delete]
  before_action :set_left_bar
  #access device: :all, message: "当前用户无权访问"

  def index
    @device_attaches = @device.device_attaches
  end

  def show
  end

  def new
    @device_attach = @device.device_attaches.build
  end

  def create
    debugger
    if params[:images]
      @device_error = []
      params[:images].each do |image|
        @device_return = @device.device_attaches.create(name: image)
        @device_error += @device_return.errors.messages.values.flatten
      end
      if @device_error.size == 0
        flash[:success] = "上传成功"
        redirect_to device_device_attaches_path(@device)
      else
        flash[:danger] = @device_error.first
        redirect_to device_device_attaches_path(@device)
      end
    else
      flash[:danger] = "不能上传空文件"
      redirect_to device_device_attaches_path(@device)
    end
  end


  def delete
  end

  def destroy
    @device_attach.destroy
    flash[:success] = "删除成功"
    redirect_to device_device_attaches_path(@device)
  end

  def delete_all
    @device = current_user.devices.find(params[:device_id])
    @device.device_attaches.destroy_all
    flash[:success] = "删除成功"
    redirect_to devices_path
  end

  private
    def device_attach_params
      params.require(:device_attach).permit(:name)
    end

    def set_device
      @device = current_user.devices.find(params[:device_id])
    end

    def set_device_attach
      @device_attach = @device.device_attaches.find(params[:id])
    end

    def set_left_bar
      @available_roles = current_user.roles.reject{ |role| (role == :user) || (role == :root_admin) }.map(&:to_s)
      @options = current_user.options.where(name: @available_roles).where(reveal: true).order(:position)
    end
end
