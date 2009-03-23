class Rating < ActiveRecord::Base
  belongs_to :ratable, :polymorphic => true, :counter_cache => :ratings_count
  validates_uniqueness_of :ratable_id, :scope => %w[user_id ratable_type]
  validates_numericality_of :score, :in => 0..5
  validates_presence_of :user_id, :ratable_id, :ratable_type, :score
  
  after_save :update_target
  
  def update_target
    changed = false
    if ratable.respond_to?(:cached_rating)
      ratable.cached_rating = Rating.average("score", :conditions => { :ratable_id => ratable_id, 
                                                                       :ratable_type => ratable_type })
      changed = true
    end
    if ratable.respond_to?(:ratings_count)
      ratable.ratings_count = ratable.ratings.count
      changed = true
    end
    ratable.save! if changed
  end
  
  def self.rate(object, user, score)
    rating = object.ratings.find_or_initialize_by_user_id(user.id)
    rating.score = score
    rating.save!
    rating
  end
end
