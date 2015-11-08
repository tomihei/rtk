class Topicvalid
  include ActiveModel::Model
  puts "model" 
  attr_accessor :title,:content,:imgurl

  validates :title, presence: true, length:{maximum:100}
  validates :content, presence: true, length:{maximum:2000}
  VALID_IMGURURL_REGEX = /\A(http\:\/\/i.imgur.com\/)(\w*)(\W*\w*)\z/
  validates :imgurl, format: {with: VALID_IMGURURL_REGEX},
            unless: Proc.new {|a| a.imgurl.blank?}

end
