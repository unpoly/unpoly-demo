class Task < ApplicationRecord
  belongs_to :tenant
  validates :text, presence: true

  has_defaults done: false

  def toggle_done!
    update!(done: !done?)
  end

  def self.clear_done!
    where(done: true).destroy_all
  end

end
