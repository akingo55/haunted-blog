# frozen_string_literal: true

class Blog < ApplicationRecord
  belongs_to :user
  has_many :likings, dependent: :destroy
  has_many :liking_users, class_name: 'User', source: :user, through: :likings
  before_save :ensure_premium_user

  validates :title, :content, presence: true

  scope :published, -> { where('secret = FALSE') }

  scope :search, lambda { |term|
    joined_term = "%#{term}%"
    where('title LIKE ? OR content LIKE ?', joined_term, joined_term)
  }

  scope :default_order, -> { order(id: :desc) }

  def owned_by?(target_user)
    user == target_user
  end

  def ensure_premium_user
    self.random_eyecatch = false unless user.premium
  end
end
