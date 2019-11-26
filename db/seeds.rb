User.create(
  name: "田中",
  email: "tanaka@example.com",
  password: 'password',
  confirmed_at: 1.month.ago
)


5.times do |n|
  name = Faker::Name.name
  email = Faker::Internet.email
  password = "password"
  User.create(
    name: name,
    email: email,
    password: password,
    confirmed_at: 1.month.ago
  )

  title = Faker::Lorem.sentence(word_count: 1)
  description = Faker::Lorem.sentence(word_count: 3)
  PostingThread.create(
    title: title,
    description: description,
    user_id: 1
  )
end
['アニメ', '映画', '小説', '漫画', 'テレビ'].each do |name|
  Category.create(
    name: name
  )
end

PostingThread.all.each do |thread|
  5.times do |n|
    content = Faker::Lorem.sentence(word_count: 2)
    Comment.create(
      content: content,
      user_id: n - 1,
      posting_thread_id: thread.id
    )
    PostingThreadCategory.create(
      category_id: n - 1,
      posting_thread_id: thread.id
    )
  end
end
