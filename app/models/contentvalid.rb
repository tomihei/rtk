class Contentvalid 
  include ActiveModel::Model
  puts "moi"
  attr_accessor :body,:imgurl,:group_id,:resid
  
  NUMORALP_REGEX = /\A[a-z\d]+\z/
  VALID_IMGURURL_REGEX = /\A(http\:\/\/i.imgur.com\/)(\w*)(\W*\w*)\z/

  validates :group_id, presence: true, length:{minimum:15,maximum:17},
            format: {with: NUMORALP_REGEX}
 
  validates :body, presence: true, length:{minimum:2,maximum:1500}
  
  validates :imgurl, format: {with: VALID_IMGURURL_REGEX},
            unless: Proc.new {|a| a.imgurl.blank?}
  
  validates :resid, length:{minimum:10,maximum:13},
            format: {with: NUMORALP_REGEX}, unless: Proc.new {|b| b.resid.blank?}
  
end
