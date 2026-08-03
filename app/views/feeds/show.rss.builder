xml.instruct! :xml, version: "1.0", encoding: "UTF-8"

xml.rss version: "2.0",
        "xmlns:atom" => "http://www.w3.org/2005/Atom",
        "xmlns:content" => "http://purl.org/rss/1.0/modules/content/" do
  xml.channel do
    xml.title feed_title
    xml.link posts_url
    xml.description site_name ? "Posts by #{site_name}." : "Posts."
    xml.language "en"
    xml.lastBuildDate @updated_at.to_time.rfc2822 if @updated_at
    xml.tag! "atom:link", rel: "self", type: "application/rss+xml", href: rss_feed_url

    @posts.each do |post|
      xml.item do
        xml.title post[:title]
        xml.link post[:url]
        xml.guid post[:url], isPermaLink: "true"
        xml.pubDate post[:date].to_time.rfc2822 if post[:date]
        xml.description post[:excerpt]
        xml.tag!("content:encoded") { xml.cdata! post[:content] }
      end
    end
  end
end
