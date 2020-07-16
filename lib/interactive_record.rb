require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord
    def self.column_names
        sql = "PRAGMA table_info(students);"
        DB[:conn].execute(sql).map{|hash| hash["name"]}
      end
  
      def initialize(options = {})
        options.each { |k, v| self.send("#{k}=", v) }
      end                               
  
      def self.table_name
        self.to_s.downcase.pluralize
      end
    #end
  
    #module InstanceMethods
  
      def table_name_for_insert
        self.class.to_s.downcase.pluralize
      end
  
      def col_names_for_insert
        self.class.column_names[1..-1].join(", ")
      end
  
      def values_for_insert
        self.class.column_names[1..-1].map {|column_name| "'#{send(column_name)}'"}.join(", ")
      end
  
      def save
        sql = "INSERT INTO #{table_name_for_insert} (#{col_names_for_insert}) VALUES (#{values_for_insert})"
        DB[:conn].execute(sql)
        self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM #{table_name_for_insert}")[0][0]
      end
  
      def self.find_by_name(name)
        sql = "SELECT * FROM #{self.table_name} WHERE name = '#{name}'"
        DB[:conn].execute(sql)
      end
    

      def self.find_by(hash)
        sql = "SELECT * FROM #{self.table_name} WHERE #{hash.keys[0].to_s} = '#{hash.values[0].to_s}'"
        DB[:conn].execute(sql)
      end
  
end