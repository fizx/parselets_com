END_PARSELET_HIGHLIGHT = 'END_PARSELET_HIGHLIGHT'
START_PARSELET_HIGHLIGHT = 'START_PARSELET_HIGHLIGHT'

Ultrasphinx::Search.excerpting_options = HashWithIndifferentAccess.new({
  :before_match => START_PARSELET_HIGHLIGHT,
  :after_match => END_PARSELET_HIGHLIGHT,
  :chunk_separator => "...",
  :limit => 256,
  :around => 3,
  :content_methods => [['code'], ['description']]
})
