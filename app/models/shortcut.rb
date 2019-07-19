class Shortcut < ApplicationRecord
  validates :slug, presence: true, uniqueness: true
  validates :target, presence: true

  def self.random_slug
    rand(36**8).to_s(36)
  end
end
