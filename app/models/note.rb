class Note < ApplicationRecord
  default_scope { order(updated_at: :desc) }
  belongs_to :user
  validate :has_title_or_body
  validate :body_length
  validate :title_length

  private
    def has_title_or_body
      unless [title, body].any?(&:present?)
        errors[:messages] << "At least one of title or body must have content!"
      end
    end
    def body_length
      # possible nils taken care of by create/update
      unless body.length<=1000
        errors[:messages] << "Body cannot exceed 1000 characters!"
      end
    end
    def title_length
      # possible nils taken care of by create/update
      unless title.length<=30
        errors[:messages] << "Title cannot exceed 30 characters!"
      end
    end

end
