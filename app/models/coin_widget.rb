class CoinWidget < ApplicationRecord
  belongs_to :cluster

  default_scope  -> { order('view_order ASC') }
end
