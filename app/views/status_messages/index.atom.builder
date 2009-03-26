atom_feed do |feed|
  feed.title("Status Updates")
  feed.updated((@status_messages.first && @status_messages.first.created_at))

  for status in @status_messages
    feed.entry(status) do |entry|
      entry.title(status.message)
      # entry.content(user.name, :type => 'text')

      entry.author do |author|
        author.name(status.user.login)
      end
    end
  end
end