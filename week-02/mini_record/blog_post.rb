require './mini_record'

class BlogPost < MiniRecord::Model
  self.table_name = :users
  self.attribute_names = [:id, :user_id, :title, :content, :created_at, :updated_at]

  def user
    User.find(self[:user_id])
  end

  def user=(user)
    self[:user_id] = user[:id]
    self.save
    user
  end
end
