class Recipe < ApplicationRecord
  belongs_to :user

  has_many :favorites, dependent: :destroy

  validates :title, presence: true, length: { maximum: 80 }
  validates :ingredients, length: { maximum: 2000 }, allow_blank: true
  validates :memo, length: { maximum: 5000 }, allow_blank: true

  validates :source_url, format: { with: /\Ahttps?:\/\/.+\z/i, message: "はhttp(s)から始まるURLを入力してください" }, allow_blank: true
end
