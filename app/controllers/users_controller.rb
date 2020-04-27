class UsersController < ApplicationController
  #prevents if any other actions are not to be accessible.
  before_action :authenticate_user!#, except: [:show]
  def show
    @user = User.find(params[:id])
    if @user.about.present? and @user.avatar.present?
      set_meta_tags title: @user.name, site: 'Mattrab '+@user.role.humanize, description: @user.about.gsub(/<[^>]*>/, '').truncate(150), keywords: @user.name,
                    og: { title: @user.name, description: @user.about.gsub(/<[^>]*>/, '').truncate(150), type: 'website', url: user_url(@user), image: @user.avatar },
                    twitter: { card: 'user', site: '@askmattrab', title: @user.name, description: @user.about.gsub(/<[^>]*>/, '').truncate(150), image: @user.avatar }
    else
      set_meta_tags title: @user.name, site: 'Mattrab '+@user.role.humanize, keywords: @user.name,
                    og: { title: @user.name, type: 'website', url: user_url(@user) },
                    twitter: { card: 'user', site: '@askmattrab', title: @user.name }
    end
    @user_notes = @user.notes.all.paginate(page: params[:page], per_page: 7).order("created_at DESC")
  end
end
