module RelationshipsHelper
  def active_relationship_for_user(current_user, user)
    current_user.active_relationships.find_by(followed_id: user.id)
  end
end
