class InfoController < ApplicationController
  def about
    @president = User.find_by id: 1
  end

  def affiliate_program
  end

  def terms
  end

  def privacy
  end
end
