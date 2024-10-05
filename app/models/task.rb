class Task < ApplicationRecord
  belongs_to :tenant
  validates :text, presence: true, uniqueness: { case_sensitive: false, scope: :tenant_id }

  has_defaults done: false

  scope :by_position, ->{ order(Arel.sql('COALESCE(position, -id)')) }

  def open?
    !done?
  end

  def finish!
    update!(done: true)
  end

  def unfinish!
    update!(done: false)
  end

  class << self

    def clear_done!
      where(done: true).destroy_all
    end

    def move_to_start!(task)
      old_list = by_position.to_a
      new_list = [task, *old_list.without(task)]
      rewrite_positions!(new_list)
    end

    def move_after!(reference, task)
      old_list = by_position.to_a
      new_list = old_list.without(task)
      reference_position = new_list.index(reference)
      new_list.insert(reference_position + 1, task)
      rewrite_positions!(new_list)
    end

    private

    def rewrite_positions!(list)
      Rails.logger.info "rewrite_positions: #{list.inspect}"
      list.each_with_index do |item, index|
        item.update_attribute(:position, index)
      end
    end

  end

end
