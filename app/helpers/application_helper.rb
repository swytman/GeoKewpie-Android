module ApplicationHelper

  def plural(n, one, few, many)
    n % 10 == 1 && n % 100 != 11 ? one : [2, 3, 4].include?(n % 10) && ![12, 13, 14].include?(n % 100) ? few : n % 10 == 0 || [5, 6, 7, 8, 9].include?(n % 10) || [11, 12, 13, 14].include?(n % 100) ? many : few
  end

  def pretty_date date,format = 'slashes'
    I18n.l date, format: format.to_sym if date.present?
  end

  def tab title, link, css_class: '', active_links: [], match_subpaths: false
    active_links = [link] + active_links
    if match_subpaths
      active = active_links.any?{ |active_link| request.path.index(active_link) }
    else
      active = active_links.include?(request.path)
    end
    class_name = active ? css_class + ' active' : css_class
    content_tag(:li, class: class_name) do
      link_to title, link
    end
  end

  #def team_title id
  #  if id.nil?
  #    return "?"
  #  else
  #    begin
  #      return Team.find(id).title
  #    rescue
  #      return "?"
  #    end
  #  end
  #end

  #def team_logo id
  #  team = Team.find(id)
  #  if team.present?
  #    ActionController::Base.helpers
  #    .image_tag(team.team_logo.logo.url(:tiny)) if team.team_logo.present?
  #  end
  #end

  def team_title_with_logo id, logo_position = :left
    return '?' if id.nil?
    team = id if id.is_a?(Team)

    team ||= Team.find(id)
    return '?' unless team.present?
    title = team.title
    logo = ActionController::Base.helpers
          .image_tag(team.team_logo.logo.url(:tiny)) if team.team_logo.present?
    if logo_position == :left
      return "#{logo}&nbsp#{title}".html_safe
    else
      return "#{title}&nbsp#{logo}".html_safe
    end
  end


end
