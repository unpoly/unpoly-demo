class Note < ApplicationRecord
  belongs_to :tenant
  validates :title, presence: true, uniqueness: { case_sensitive: false, scope: :tenant_id }
  validates :text, presence: true, length: { minimum: 20 }
end
