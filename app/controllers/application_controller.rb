class ApplicationController < ActionController::Base
  allow_browser versions: :modern, unless: -> { request.format.rss? }

  def not_found
    render file: Rails.root.join("public", "404.html"), status: :not_found
  end
end