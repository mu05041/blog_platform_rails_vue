# 카테고리 생성
puts "Creating categories..."
categories = [
  'Travel',
  'Food',
  'Lifestyle',
  'Technology',
  'Sports',
  'Music'
]

categories.each do |category_name|
  Category.find_or_create_by(name: category_name) do |category|
    category.description = "Posts related to #{category_name.downcase}"
  end
end

# 태그 생성
puts "Creating tags..."
tags = [
  'Sunny',
  'Cloudy',
  'Rainy',
  'Snowy',
  'Windy',
  'Stormy'
]

tags.each do |tag_name|
  Tag.create(name: tag_name) unless Tag.exists?(name: tag_name)
end

# 사용자 생성
puts "Creating users..."
users = [
  { username: 'admin', email: 'admin@example.com', password: 'password123' },
  { username: 'john', email: 'john@example.com', password: 'password123' },
  { username: 'jane', email: 'jane@example.com', password: 'password123' }
]

user_objects = {}
users.each do |user|
  user_objects[user[:username]] = User.create!(
    username: user[:username],
    email: user[:email],
    password: user[:password]
  )
end

# 포스트 생성
puts "Creating posts..."
posts = [
  {
    title: '일본 여행기',
    content: '일본 여행은 정말 멋졌습니다. 음식, 문화, 사람들 모두 환상적이었습니다.',
    published: true,
    user: 'john',
    category: 'Travel',
    tag: 'Sunny'
  },
  {
    title: '도시의 라멘 맛집',
    content: '도시의 모든 라멘 가게를 시도해 봤는데, 이 곳이 제일 맛있습니다.',
    published: true,
    user: 'jane',
    category: 'Food',
    tag: 'Rainy'
  },
  {
    title: 'Ruby on Rails 소개',
    content: 'Ruby on Rails는 빠른 개발을 가능하게 하는 강력한 웹 프레임워크입니다.',
    published: true,
    user: 'admin',
    category: 'Technology',
    tag: 'Cloudy'
  }
]

posts.each do |post_data|
  post = Post.create!(
    title: post_data[:title],
    content: post_data[:content],
    published: post_data[:published],
    user: user_objects[post_data[:user]]
  )
  
  # 포스트-카테고리 연결
  category = Category.find_by(name: post_data[:category])
  if category
    PostCategory.create!(
      post: post,
      category: category
    )
  end
  
  # 포스트-태그 연결
  tag = Tag.find_by(name: post_data[:tag])
  if tag
    PostTag.create!(
      post: post,
      tag: tag
    )
  end
end

puts "Seed data created successfully!"
puts "Categories: #{Category.count}"
puts "Tags: #{Tag.count}"
puts "Users: #{User.count}"
puts "Posts: #{Post.count}"
puts "PostCategories: #{PostCategory.count}"
puts "PostTags: #{PostTag.count}"