class Favorite < ActiveRecord::Base
  belongs_to :favoritable, :polymorphic => true
  validates_uniqueness_of :favoritable_id, :scope => %w[user_id favoritable_type]
  validates_presence_of :user_id, :favoritable_id, :favoritable_type

  def self.favorite(object, user)
    favorite = object.favorites.find_or_initialize_by_user_id(user.id)
    favorite.save!
    favorite
  end
  
  def self.toggle(params, user)
    raise Exception.new("Invalid favoritable_type") unless %w[Parselet].include?(params[:favoritable_type])
    favorite = Favorite.find_or_initialize_by_user_id_and_favoritable_id_and_favoritable_type(user.id, 
                                                                                              params[:favoritable_id], 
                                                                                              params[:favoritable_type])
    raise Exception.new("Invalid favoritable_id") unless favorite.favoritable

    if favorite.new_record?
      favorite.save!
    else
      favorite.destroy
    end
    favorite
  end
  
  def self.find_for_favoritable(favoritable, user)
    favoritable.favorites.find_by_user_id(user.id)
  end
end
