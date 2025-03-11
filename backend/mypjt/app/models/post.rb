class Post < ApplicationRecord
  belongs_to :user

    # 카테고리 관계 설정
    has_many :post_categories
    has_many :categories, through: :post_categories
    
    # 태그 관계 설정
    has_many :post_tags
    has_many :tags, through: :post_tags

    has_many :comments

end
