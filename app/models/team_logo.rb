class TeamLogo < ActiveRecord::Base
  has_attached_file :logo,
                    :url => "/system/assets/team_logos/:id/:style/:filename",
                    :path => ":rails_root/public/system/assets/team_logos/:id/:style/:filename",
                    :styles => { :tiny => "16x16", :mini => "32x32", :standart => "120x120" },
                    :default_url => "/images/:style/missing.png",
                    :convert_options => {:all => '-background transparency'
                                        }
  validates_attachment_content_type :logo, :content_type => /\Aimage/

  def self.available_logo champ, team
    group_key = champ.group_key
    champs = Champ.where(group_key: group_key)
    t_ids = champs.collect(&:team_ids).flatten
    used_logo_ids = Team.where(id: t_ids).collect(&:team_logo_id) - [team.team_logo_id]
    TeamLogo.where.not(id: used_logo_ids)
  end



end