# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def page_title title
    content_for(:page_title) { h(title) }
  end

  def html_class class_name
    content_for(:html_class) { class_name.to_s }
  end

  def body_class class_name
    content_for(:body_class) { class_name.to_s }
  end

  def get_default_url
    "heroku.com"
  end

  FLASH_TYPES = [:error, :notice, :info]
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
