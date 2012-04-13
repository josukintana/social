class Wallevent < ActiveRecord::Base
  belongs_to :activity
  belongs_to :wall
end
