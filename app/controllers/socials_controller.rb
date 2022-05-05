class SocialsController < ApplicationController

  def update
    @social = Social.find(params[:id])
    @user = User.find(@social.user_id)
    @social.update(social_params)
    redirect_to edit_user_path(@user)
  end

  def social_params
    params.require(:social).permit(:instagram, :github, :tiktok, :facebook, :medium)
  end
end
