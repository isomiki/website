class PagesController < ApplicationController
  def home
  end

  def summary
  end

  def projects
  end

  def tools
  end

  def contact
  end

  def posts
  end

  def crypto
  end

  def misc
  end

  def miscpage
    page = params[:page]
    render "pages/misc/#{page}"
  end
end
