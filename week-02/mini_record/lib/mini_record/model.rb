module MiniRecord

  class Model
    # Attribute names are at the class level since they're "schema" data
    def self.attribute_names
      @attribute_names
    end

    def self.attribute_names=(attribute_names)
      @attribute_names = attribute_names.map { |attr_name| attr_name.to_sym }
      @attribute_names.freeze
    end

    def self.attribute?(attr_name)
      attribute_names.include?(attr_name.to_sym)
    end

    def attribute_names
      self.class.attribute_names
    end

    def attribute?(attr_name)
      self.class.attribute?(attr_name)
    end

    def table_name
      self.class.table_name
    end

    def table_name=(table_name)
      @table_name.class
    end

    def table_name_plural
        table_name_plural = @table_name.split(/(?=[A-Z])/)
        table_name_plural.join("_").downcase + 's'
    end

    def self.all
      MiniRecord::Database.execute("SELECT * FROM #{table_name_plural}").map do |row|
        table_name.new(row)
      end
    end

    def self.where(query, *args)
      MiniRecord::Database.execute("SELECT * FROM #{table_name_plural} WHERE #{query}", *args).map do |row|
        table_name.new(row)
      end
    end

    def self.find(pk)
      where('id = ?', pk).first
    end

    def self.create(attributes = {})
      # See http://ruby-doc.org/core-2.1.2/Object.html#method-i-tap
      @table_name.new(attributes).tap do |user|
        user.save
      end
    end

    def initialize(attributes = {})
      # See lib/mini_record/ext/hash.rb for how these methods are defined.
      attributes.symbolize_keys!
      attributes.assert_valid_keys(@table_name.attribute_names)

      @attributes = {}

      @table_name.attribute_names.each do |attr_name|
        @attributes[attr_name] = attributes[attr_name]
      end
    end

    def new_record?
      read_attribute(:id).nil?
    end

    def save
      if new_record?
        insert_record!
      else
        update_record!
      end
    end

    def read_attribute(attr_name)
      @attributes[attr_name]
    end
    alias_method :[], :read_attribute

    def write_attribute(attr_name, value)
      attr_name = attr_name.to_sym

      if attribute?(attr_name)
        @attributes[attr_name] = value
      else
        fail MiniRecord::MissingAttributeError, "can't write unknown attribute `#{attr_name}'"
      end
    end
    alias_method :[]=, :write_attribute

    private

    def insert_record!
      now = DateTime.now

      write_attribute(:created_at, now) if attribute?(:created_at)
      write_attribute(:updated_at, now) if attribute?(:updated_at)

      values  = @attributes.values

      MiniRecord::Database.execute(insert_sql, *values).tap do
        # We don't have a value for id until we insert the database, so fetch
        # the last insert ID after a successful insert and update our Ruby model.
        write_attribute(:id, MiniRecord::Database.last_insert_row_id)
      end

      true
    end

    def update_record!
      write_attribute(:updated_at, DateTime.now) if attribute?(:updated_at)

      values  = @attributes.values
      MiniRecord::Database.execute(update_sql, *values, read_attribute(:id))

      true
    end

    def insert_sql
      columns = @attributes.keys

      placeholders  = Array.new(columns.length, '?').join(',')

      "INSERT INTO #{table_name_plural} (#{columns.join(',')}) VALUES (#{placeholders})"
    end

    def update_sql
      columns = @attributes.keys

      set_clause = columns.map { |col| "#{col} = ?" }.join(',')

      "UPDATE #{table_name_plural} SET #{set_clause} WHERE id = ?"
    end
  end
end
