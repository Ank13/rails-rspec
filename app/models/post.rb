class Post < ActiveRecord::Base
  attr_accessible :title, :content, :is_published

  scope :recent, order: "created_at DESC", limit: 5

  before_save :titleize_title

  validates_presence_of :title, :content

  after_save :parameterize_title


  private

  def titleize_title
    self.title = title.titleize
  end

  def parameterize_title
    self.slug = title.parameterize
  end


end

