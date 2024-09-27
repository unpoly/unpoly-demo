class Task < ApplicationRecord
  belongs_to :tenant
  validates :text, presence: true, uniqueness: { case_sensitive: false, scope: :tenant_id }

  has_defaults done: false

  def open?
    !done?
  end

  def finish!
    update!(done: true)
  end

  def unfinish!
    update!(done: false)
  end

  def self.clear_done!
    where(done: true).destroy_all
  end

end
