class Book
  attr_accessor :title, :author, :rentals, :index

  def initialize(title, author, index = 0)
    @title = title
    @author = author
    @rentals = []
    @index = index
  end

  def add_rental(date, person)
    Rental.new(date, self, person)
  end
  def to_json(*_args)
    { title: @title, author: @author, index: @index }.to_json
  end
end
