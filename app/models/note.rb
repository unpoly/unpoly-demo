class Note < ApplicationRecord
  MIN_TITLE_LENGTH = 10

  belongs_to :tenant
  validates :title, presence: true, length: { minimum: MIN_TITLE_LENGTH }, uniqueness: { case_sensitive: false, scope: :tenant_id }
  validates :body, presence: true, length: { minimum: 30 }

  TAGS = %w[
    web-development
    frontend
    backend
    full-stack
    ruby-on-rails
    javascript
    typescript
    react
    vue
    svelte
    html
    css
    tailwind-css
    responsive-design
    accessibility
    performance
    seo
    api-design
    rest
    graphql
    authentication
    authorization
    security
    testing
    tdd
    bdd
    devops
    ci-cd
    docker
    kubernetes
    cloud-deployment
    serverless
    database-design
    postgresql
    mysql
    redis
    caching
    scalability
    architecture
    microservices
    websockets
    real-time
    progressive-web-apps
    browser-compatibility
    debugging
    code-quality
    best-practices
    developer-tools
    open-source
    version-control
    git-workflow
  ].sort.freeze

  def self.random_body(paragraph_count = nil)
    paragraph_count ||= (3..7).to_a.sample

    paragraph_count.times.map {
      Faker::Lorem.paragraph(sentence_count: 6,  random_sentences_to_add: 10)
    }.join("\n\n")
  end

  def self.random_title
    loop do
      title = Faker::Book.unique.title
      return title if title.length >= MIN_TITLE_LENGTH
    end
  end

end
