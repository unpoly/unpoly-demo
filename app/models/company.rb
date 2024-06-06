class Company < ActiveRecord::Base
  belongs_to :tenant
  has_many :projects, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :tenant_id }
  validates :address, presence: true

  def self.search(query)
    if query.present?
      where_like([:name, :address] => query)
    else
      all
    end
  end

end
