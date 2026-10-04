require 'commonmarker'

class FeedsController < ApplicationController
  FEED_LIMIT = 50

  DATE_LINE = /\A\s*(\d{4}-\d{2}-\d{2})\s*\z/

  def show
    @posts = feed_posts
    @updated_at = @posts.filter_map { |post| post[:date] }.max

    response.headers["Content-Disposition"] = ActionDispatch::Http::ContentDisposition.format(
      disposition: "inline",
      filename: feed_filename
    )

    render :show, formats: :rss, layout: false, content_type: "text/xml"
  end

  private

  def feed_filename
    "#{helpers.site_name&.parameterize.presence || 'posts'}.xml"
  end

  def feed_posts
    helpers.load_posts.to_a.first(FEED_LIMIT).filter_map do |post|
      filepath = Rails.root.join("app", "posts", "#{post[:file_name]}.md")
      next unless File.exist?(filepath)

      markdown_content = File.read(filepath)

      post.merge(
        date: post_date(markdown_content),
        content: post_html(markdown_content),
        excerpt: excerpt_for(markdown_content),
        url: post_url(name: post[:file_name])
      )
    end
  end

  def post_date(markdown_content)
    date = preamble(markdown_content).filter_map { |line| line[DATE_LINE, 1] }.first

    (Time.zone.parse(date) if date) rescue nil
  end

  def post_html(markdown_content)
    absolutize(render_markdown(markdown_content))
  end

  def render_markdown(markdown_content)
    Commonmarker.to_html(
      markdown_content,
      options: {
        extensions: {
          header_ids: false
        }
      }
    )
  end

  def absolutize(html)
    html.gsub(%r{(href|src)="/(?!/)}) { "#{$1}=\"#{request.base_url}/" }
  end

  def excerpt_for(markdown_content)
    body = markdown_content.lines.drop_while { |line| preamble_line?(line) }.join
    text = helpers.strip_tags(render_markdown(body)).to_s

    CGI.unescapeHTML(text).squish.truncate(300)
  end

  def preamble(markdown_content)
    markdown_content.lines.take_while { |line| preamble_line?(line) }
  end

  def preamble_line?(line)
    line.blank? || line.start_with?("#") || line.match?(DATE_LINE)
  end
end
