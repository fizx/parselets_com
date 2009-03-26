atom_feed do |feed|
  append = @parselet ? " on #{@parselet.name}" : ""
  feed.title("Recent comments#{append}")
  feed.updated((@comments.first && @comments.first.created_at))

  for comment in @comments
    feed.entry(comment) do |entry|
      entry.title("Comment by #{comment.user.login}")
      entry.content(comment.content, :type => 'text')

      entry.author do |author|
        author.name(comment.user.login)
      end
    end
  end
end