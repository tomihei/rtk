class Topic < ActiveRecord::Base
 validates :title, presence: true, length:{maximum:100}
 validates :key, presence:true
end
