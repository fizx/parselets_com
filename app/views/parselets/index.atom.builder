atom_feed do |feed|
  feed.title("Recent parselets")
  feed.updated((@parselets.first && @parselets.first.created_at))

  for parselet in @parselets
    feed.entry(parselet) do |entry|
      entry.title(parselet.name)
      if @show_history
        
      entry.content(parselet.summary, :type => 'text')

      entry.author do |author|
        author.name(parselet.user.login)
      end
    end
  end
end