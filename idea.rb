require 'yaml/store'

class Idea
  attr_reader :title, :description, :tag, :id

  def initialize(attributes)
    @title = attributes[:title]
    @description = attributes[:description]
    @tag = attributes[:tag] || ""
  end

  def self.delete(position)
    database.transaction do
      database['ideas'].delete_at(position)
    end
  end

  def self.all
    raw_ideas.map do |data|
      new(data)
    end
  end

  def self.raw_ideas
    database.transaction do |db|
      db['ideas'] || []
    end
  end

  def save
    database.transaction do |db|
    db['ideas'] ||= []
    db['ideas'] << {title: title, description: description, tag: tag}
    end
  end

  def self.database
    @database ||= YAML::Store.new("ideabox")
  end

  def database
    Idea.database
  end

  def self.find(id)
    raw_idea = find_raw_idea(id)
    new(raw_idea)
  end

  def self.find_raw_idea(id)
    database.transaction do
      database['ideas'].at(id)
    end
  end

  def self.update(id, data)
    database.transaction do
      database['ideas'][id] = data
    end
  end

  def self.search(terms)
    all.find_all do |idea| 
      idea.title.downcase.include?(terms.downcase) || 
      idea.description.downcase.include?(terms.downcase) ||
      idea.tag.downcase.include?(terms.downcase)
    end
  end

end
