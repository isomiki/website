module ApplicationHelper
  def page_title
    case request.host
    when "marinbelec.com", "mrnb.net", "bel.ec", "127.0.0.1"
      "Marin Belec"
    when "isomiki.com"
      "isomiki"
    else
      "Welcome"
    end
  end

  def contact_email
    fallback_email = "(hidden)"
    case request.host
    when "marinbelec.com"
      ENV["EMAIL_MARINBELEC"] || fallback_email
    when "mrnb.net"
      ENV["EMAIL_MRNB"] || fallback_email
    when "bel.ec"
      ENV["EMAIL_BELEC"] || fallback_email
    when "isomiki.com"
      ENV["EMAIL_ISOMIKI"] || fallback_email
    else
      fallback_email
    end
  end
  
  def render_my_time_partial
    local_time = Time.now.in_time_zone('Europe/Berlin')
    local_time_formatted = local_time.strftime("%b %d %H:%M")
    local_time_iso = local_time.strftime("%Y-%m-%dT%H:%M:%S")

    render partial: 'pages/partials/my_time', locals: {
      local_time_formatted: local_time_formatted,
      local_time_iso: local_time_iso
    }
  end

  def load_posts
    posts_dir = Rails.root.join("app", "posts")
    post_entries = []

    if Dir.exist?(posts_dir)
      file_names = Dir.children(posts_dir)
                      .select { |name| File.file?(posts_dir.join(name)) }
                      .sort.reverse

      index = file_names.size

      file_names.each do |file_name|
        file_path = posts_dir.join(file_name)
        first_line = File.open(file_path, &:readline).strip rescue nil

        if first_line
          title = first_line.sub(/^#*\s*/, '')
          post_entries << {
            index: index,
            title: title,
            file_name: file_name.sub(/\.md\z/, '')
          }
        end

        index -= 1
      end
    else
      post_entries = nil
    end

    post_entries
  end

  TOOLS_LIST = {
    "one" => "One",
    "two" => "Two",
  }
  
  def load_tools
    tool_entries = []

    TOOLS_LIST.each do |id, title|
      tool_entries << {
        id: id,
        title: title,
      }
    end

    tool_entries
  end

  def misc_md_dir
    Rails.root.join("app", "misc-md")
  end

  def render_md(file_path)
    content = File.read(file_path)
    Commonmarker.to_html(content).html_safe
  end
end
