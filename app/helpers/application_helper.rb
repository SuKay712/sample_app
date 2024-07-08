module ApplicationHelper
  def full_title title = ""
    base_title = t("base_title")
    title.blank? ? base_title : "#{title} | #{base_title}"
  end
end
