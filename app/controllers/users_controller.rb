class UsersController < ApplicationController
  #prevents if any other actions are not to be accessible.
  before_action :authenticate_user!, except: [:show, :google_oauth2, :failure]
  before_action :find_user, only: [:show, :change_role]
  def show
    if params[:tab].present?
      @tab = params[:tab]
    elsif @user.creator? or @user.admin? or @user.executive? or @user.teacher? or @user.superadmin?
      @tab = "note"
    else
      @tab = "question"
    end

    case @tab
    when "question"
      @questions = @user.questions.all.paginate(page: params[:page], per_page: 7).order("created_at DESC")
    when "answer"
      @questions = @user.answered_questions.uniq.paginate(page: params[:page], per_page: 7)
    when "about"
      @total_views = @user.notes.sum(:view) #+ @user.questions.sum(:view)
    else
      if @user == current_user or (user_signed_in? and current_user.admin?)
        @notes = @user.notes.all.paginate(page: params[:page], per_page: 7).order("created_at DESC")
      else
        @notes = @user.notes.published.paginate(page: params[:page], per_page: 7).order("created_at DESC")
      end
    end

    if @user.about.present? and @user.avatar.present?
      set_meta_tags title: @user.name, site: 'Mattrab '+@user.role.humanize, description: @user.about.gsub(/<[^>]*>/, '').truncate(150), keywords: "#{@user.name}, Mattrab #{@user.role}, Mattrab user",
                    og: { title: @user.name, description: @user.about.gsub(/<[^>]*>/, '').truncate(150), type: 'website', url: user_url(@user), image: @user.avatar },
                    twitter: { title: @user.name, description: @user.about.gsub(/<[^>]*>/, '').truncate(150), image: @user.avatar }
    else
      set_meta_tags title: @user.name, site: 'Mattrab '+@user.role.humanize, keywords: "#{@user.name}, Mattrab #{@user.role}, Mattrab user",
                    og: { title: @user.name, type: 'website', url: user_url(@user) },
                    twitter: { title: @user.name }
    end
  end

  def change_role
    @user.update_attribute(:role, params[:role].to_i)
    redirect_back fallback_location: @user
  end

  def google_oauth2
    @user = User.from_omniauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
    else
      session['devise.google_data'] = @user.attributes
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end

  def failure
    flash[:error] = "Couldn't sign in. Please try again."
    redirect_to new_user_registration_url
  end

  private

  def find_user
    @user = User.find(params[:id])
  end
end
