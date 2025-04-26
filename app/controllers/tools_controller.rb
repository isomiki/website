class ToolsController < ApplicationController
  def show
    tool_template = "tools/#{params[:name]}"
    puts "Looking for template: #{tool_template}"  # Debugging line
    
    filepath = Rails.root.join("app", "views", "tools", "#{params[:name]}.html.erb")
    unless File.exist?(filepath)
      redirect_to '/not-found' and return
    end

    render tool_template
  end
end