module IconsHelper
  def fa_icon(icon)
    tag(:i, class: "fa fa-#{icon}")
  end

  def show_icon
    fa_icon('eye')
  end

  def edit_icon
    fa_icon('pencil')
  end

  def remove_icon
    fa_icon('trash')
  end
end
