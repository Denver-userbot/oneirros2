class RivalWar < ApplicationRecord
  attribute :rivals_id, :big_integer 
  attribute :attacking_region, :big_integer
  attribute :defending_region, :big_integer
  attribute :wallsnapshot, :big_integer
  enum :wartype: [ :land, :air, :trooper, :sea, :training, :space, :coup ]

end


