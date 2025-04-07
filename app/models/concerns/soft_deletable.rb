# app/models/concerns/soft_deletable.rb
module SoftDeletable
  extend ActiveSupport::Concern

  included do
    default_scope { where(deleted_at: nil) }

    scope :with_deleted, -> { unscope(where: :deleted_at) }
    scope :only_deleted, -> { where.not(deleted_at: nil) }

    def soft_delete!
      update(deleted_at: Time.current)
    end

    def restore!
      update(deleted_at: nil)
    end

    def deleted?
      deleted_at.present?
    end
  end
end
