class Cluster < ApplicationRecord
  belongs_to :user
  has_many :coin_widgets, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :sorted_by_view_order, -> { order('view_order ASC') }
end
