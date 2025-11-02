class Note < ApplicationRecord
  belongs_to :tenant
  validates :title, presence: true, uniqueness: { case_sensitive: false, scope: :tenant_id }
  validates :body, presence: true, length: { minimum: 20 }
end
