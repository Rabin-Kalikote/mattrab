class UsersController < ApplicationController
  #prevents if any other actions are not to be accessible.
  before_action :authenticate_user!, except: [:show]
  def show
    @user = User.find(params[:id])
    @tab = params[:tab]

    case @tab
    when "question"
      @questions = @user.questions.all.paginate(page: params[:page], per_page: 7).order("created_at DESC")
    when "answer"
      @questions = @user.answered_questions.uniq.paginate(page: params[:page], per_page: 7)
    when "about"
      @total_views = @user.notes.sum(:view) #+ @user.questions.sum(:view)
    else
      @notes = @user.notes.all.paginate(page: params[:page], per_page: 7).order("created_at DESC")
      @tab = "note"
    end

    if @user.about.present? and @user.avatar.present?
      set_meta_tags title: @user.name, site: 'Mattrab '+@user.role.humanize, description: @user.about.gsub(/<[^>]*>/, '').truncate(150), keywords: @user.name,
                    og: { title: @user.name, description: @user.about.gsub(/<[^>]*>/, '').truncate(150), type: 'website', url: user_url(@user), image: @user.avatar },
                    twitter: { card: 'user', site: '@askmattrab', title: @user.name, description: @user.about.gsub(/<[^>]*>/, '').truncate(150), image: @user.avatar }
    else
      set_meta_tags title: @user.name, site: 'Mattrab '+@user.role.humanize, keywords: @user.name,
                    og: { title: @user.name, type: 'website', url: user_url(@user) },
                    twitter: { card: 'user', site: '@askmattrab', title: @user.name }
    end
  end
end
