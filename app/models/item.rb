class Item < ActiveRecord::Base
  belongs_to :list
  delegate :user, to: :list

  validates_presence_of :description
  validates_uniqueness_of :description

  scope :completed, -> { where(completed: false) }

  def mark_complete
    update_attribute(:completed, true)
  end
end
