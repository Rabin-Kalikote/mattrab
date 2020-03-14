class InfoController < ApplicationController
  def about
    @president = User.find_by id: 1
    @p_admins = User.where(:admin_category => "physics").where.not( :id => "1")
    @c_admins = User.where(:admin_category => "chemistry")
    @b_admins = User.where(:admin_category => "biology")
    @m_admins = User.where(:admin_category => "maths")
    @n_admins = User.where(:admin_category => "nepali")
    @e_admins = User.where(:admin_category => "english")
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
