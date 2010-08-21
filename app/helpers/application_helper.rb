# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def page_title title
    content_for(:page_title) { title }
  end

  def html_class class_name
    content_for(:html_class) { "class='#{class_name}'" }
  end


  FLASH_TYPES = [:error, :notice, :warning]
  def flash_messages
    keys = FLASH_TYPES & flash.keys
    return "" if keys.empty?

    content_tag :div, :id => "messages" do
      keys.map do |type|
        content_tag :div, :class => "flash #{type.to_s}" do
          flash[type]
        end
      end.join
    end
  end
end
