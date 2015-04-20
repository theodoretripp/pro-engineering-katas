require './mini_record'

class User < MiniRecord::Model
  self.table_name = :blog_posts
  self.attribute_names = [:id, :first_name, :last_name, :email, :birth_date, :created_at, :updated_at]

  def blog_posts
    BlogPost.where('user_id = ?', self[:id])
  end

  def create_blog_post(attributes = {})
    attributes[:user_id] = self[:id]
    BlogPost.create(attributes)
  end
end
