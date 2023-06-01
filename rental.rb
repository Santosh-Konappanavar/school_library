class Rental
  attr_accessor :date, :person, :book

  def initialize(date, person, book)
    @date = date
    @person = person
    @book = book
    book.rentals << self
    person.rentals << self
  end
  
  def to_json(*_args)
    {
      date: @date,
      person: @person,
      book: @book
    }.to_json
  end
end
