class Rating < ActiveRecord::Base
  belongs_to :ratable, :polymorphic => true
  validates_uniqueness_of :ratable_id, :scope => %w[user_id ratable_type]
  validates_numericality_of :score, :in => 0..5
  validates_presence_of :user_id, :ratable_id, :ratable_type, :score
  
  def self.rate(object, user, score)
    rating = find_or_initialize_by_ratable_id_and_ratable_type_and_user_id(object.id, object.class.to_s, user.id)
    rating.score = score
    rating
  end
end
