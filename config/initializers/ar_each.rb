class <<ActiveRecord::Base
  def each(limit=1000)
    rows = find(:all, :conditions => ["id > ?", 0], :limit => limit)
    while rows.any?
      rows.each { |record| yield record }
      rows = find(:all, :conditions => ["id > ?", rows.last.id], :limit => limit)
    end
    self
  end
end