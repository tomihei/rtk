class Topicvalid
  include ActiveModel::Model
  puts "model" 
  attr_accessor :title,:content

  validates :title, presence: true, length:{maximum:100}
  validates :content, presence: true, length:{maximum:2000}
end
