class Note < ApplicationRecord
  belongs_to :tenant
  validates :title, presence: true, length: { minimum: 10 }, uniqueness: { case_sensitive: false, scope: :tenant_id }
  validates :body, presence: true, length: { minimum: 30 }

  def self.random_body(paragraph_count = nil)
    paragraph_count ||= (3..7).to_a.sample

    paragraph_count.times.map {
      Faker::Lorem.paragraph(sentence_count: 6,  random_sentences_to_add: 10)
    }.join("\n\n")
  end

end
