atom_feed do |feed|
  feed.title("Recent users")
  feed.updated((@users.first && @users.first.created_at))

  for user in @users
    feed.entry(user) do |entry|
      entry.title(user.login)
      entry.content(user.name, :type => 'text')

      entry.author do |author|
        author.name(user.login)
      end
    end
  end
end