class InfoController < ApplicationController
  def about
    @president = User.find_by id: 1
    @p_admins = User.where(:admin_category => "physics").where.not( :id => "1").order("created_at ASC")
    @c_admins = User.where(:admin_category => "chemistry").order("created_at ASC")
    @b_admins = User.where(:admin_category => "biology").order("created_at ASC")
    @m_admins = User.where(:admin_category => "maths").order("created_at ASC")
    @n_admins = User.where(:admin_category => "nepali").order("created_at ASC")
    @e_admins = User.where(:admin_category => "english").order("created_at ASC")
  end

  def affiliate_program
  end

  def terms
  end

  def privacy
  end

  def creator_appeal
  end
end
