class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # Feed readers aren't browsers, so don't gate the feed on browser version.
  allow_browser versions: :modern, unless: -> { request.format.rss? }

  def not_found
    render file: Rails.root.join("public", "404.html"), status: :not_found
  end
end