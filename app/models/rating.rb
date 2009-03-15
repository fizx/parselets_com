class Rating < ActiveRecord::Base
  belongs_to :ratable, :polymorphic => true, :counter_cache => :ratings_count
  validates_uniqueness_of :ratable_id, :scope => %w[user_id ratable_type]
  validates_numericality_of :score, :in => 0..5
  validates_presence_of :user_id, :ratable_id, :ratable_type, :score
  
  after_save :update_target
  
  def update_target
    if ratable.respond_to?(:cached_rating)
      ratable.update_attribute(:cached_rating, Rating.average("score", :conditions => {:ratable_id => ratable_id, :ratable_type => ratable_type}))
    end
  end
  
  def self.rate(object, user, score)
    rating = object.ratings.find_or_initialize_by_user_id(user.id)
    rating.score = score
    rating.save
    object.update_attribute(:ratings_count, object.ratings.count)
    rating
  end
end
