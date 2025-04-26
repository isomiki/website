require 'commonmarker'

class PostsController < ApplicationController
  def show
    filename = "#{params[:name]}.md"
    filepath = Rails.root.join("app", "posts", filename)

    unless File.exist?(filepath)
      redirect_to '/not-found' and return
    end

    markdown_content = File.read(filepath)

    @post_html = Commonmarker.to_html(
      markdown_content,
      options: {
        extensions: {
          header_ids: false
        }
      }
    ).html_safe
  end
end