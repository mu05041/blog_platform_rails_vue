# カテゴリ作成
puts "カテゴリを作成中..."
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

# タグ作成
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

# ユーザー作成
puts "ユーザーを作成中..."
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

# 記事を作成
puts "Creating posts..."
posts = [
  {
    title: "アメリカ旅行記",
    content: "アメリカ旅行は本当に充実していました。広大な自然、多様な都市、様々な文化体験ができました。特にグランドキャニオンの景色とニューヨークの活気は忘れられません。アメリカ料理も予想以上に美味しく、人々の親切さにも感動しました。",
    published: true,
    user: "john",
    category: "Travel",
    tag: "Sunny"
  },
  {
    title: '都市のラーメン名店',
    content: '都市のすべてのラーメン店を試してみましたが、ここが一番美味しいです。',
    published: true,
    user: 'jane',
    category: 'Food',
    tag: 'Rainy'
  },
  {
    title: 'Ruby on Railsの紹介',
    content: 'Ruby on Railsは迅速な開発を可能にする強力なWebフレームワークです。',
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
  
  # 記事ーカテゴリ紐付け
  category = Category.find_by(name: post_data[:category])
  if category
    PostCategory.create!(
      post: post,
      category: category
    )
  end
  
  # 記事ータグ紐付け
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