require 'commonmarker'

# Serves the posts feed. Routed at both /rss and /feed.
class FeedsController < ApplicationController
  FEED_LIMIT = 50

  # A date on its own line near the top of a post, e.g. "2026-07-22".
  DATE_LINE = /\A\s*(\d{4}-\d{2}-\d{2})\s*\z/

  def show
    @posts = feed_posts
    @updated_at = @posts.filter_map { |post| post[:date] }.max

    # Without this the saved file is named after the path it came from, so the
    # same feed lands as rss.rss or feed.rss. "inline" keeps it displaying in
    # the browser rather than forcing a download.
    response.headers["Content-Disposition"] = ActionDispatch::Http::ContentDisposition.format(
      disposition: "inline",
      filename: feed_filename
    )

    # Served as text/xml rather than the stricter application/rss+xml so
    # browsers render it instead of downloading it — they have a viewer for
    # generic XML but none for the RSS type. Feed readers parse the body and
    # don't mind; autodiscovery still advertises application/rss+xml.
    render :show, formats: :rss, layout: false, content_type: "text/xml"
  end

  private

  # Named after the site, not the path it was fetched from. The extension has
  # to match the content type served, or browsers append their own and the
  # file saves as marin-belec.rss.xml.
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

  # A post may open with a bare ISO date under its title. Anything else — a
  # hedged "2025 November I think", an evergreen page with no date at all — is
  # left undated. RSS has no way to say "roughly November", and a guessed
  # timestamp would contradict what the post itself says, so we publish none.
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

  # Feed readers render the content away from the site, so root-relative
  # links have to be rewritten to full URLs.
  def absolutize(html)
    html.gsub(%r{(href|src)="/(?!/)}) { "#{$1}=\"#{request.base_url}/" }
  end

  # The title and date already have their own places in the item, so start the
  # summary at the prose.
  # Rendered first, so markdown syntax doesn't leak into the plain-text summary.
  def excerpt_for(markdown_content)
    body = markdown_content.lines.drop_while { |line| preamble_line?(line) }.join
    text = helpers.strip_tags(render_markdown(body)).to_s

    CGI.unescapeHTML(text).squish.truncate(300)
  end

  # Everything above the first line of prose. Scanning only here keeps a bare
  # date further down the post from being read as its publication date.
  def preamble(markdown_content)
    markdown_content.lines.take_while { |line| preamble_line?(line) }
  end

  def preamble_line?(line)
    line.blank? || line.start_with?("#") || line.match?(DATE_LINE)
  end
end
