class WidgetsController < ApplicationController

  def update
    @widget = Widget.find(params[:id])
    @user = User.find(@widget.user_id)
    @widget.update(widget_params)
    redirect_to edit_user_path(@user)
  end

  def widget_params
    params.require(:widget).permit(:mirror, :nfts, :projects)
  end
end
