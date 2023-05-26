require_relative 'app'

def main
  books = []
  people = []
  rentals = []

  loop do
    display

    option = gets.chomp.to_i
    puts ''

    handler(option, books, people, rentals)

    break if option == 7
  end
end

def display
  puts 'Library Management System'
  puts '1. List all books'
  puts '2. List all people'
  puts '3. Create a person'
  puts '4. Create a book'
  puts '5. Create a rental'
  puts '6. List rentals for a person'
  puts '7. Quit'
  print 'Select an option: '
end

def handler(option, books, people, rentals)
  optionactions = {
    1 => -> { all_books(books) },
    2 => -> { all_people(people) },
    3 => -> { create_person(people) },
    4 => -> { create_book(books) },
    5 => -> { create_rental(people, books, rentals) },
    6 => -> { list_rentals(rentals) },
    7 => -> { quit }
  }

  action = optionactions[option]
  if action
    action.call
  else
    puts 'Invalid option!'
  end
end

main
