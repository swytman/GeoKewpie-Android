class TeamLogo < ActiveRecord::Base
  has_attached_file :logo,
                    :url => "/system/team_logos/:id/:style/:filename",
                    :path => ":rails_root/public/system/team_logos/:id/:style/:filename",
                    :styles => { :tiny => "16x16", :mini => "32x32", :standart => "120x120" },
                    :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :logo, :content_type => /\Aimage/
end