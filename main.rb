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
  menu = {
    1 => 'List all books',
    2 => 'List all people',
    3 => 'Create a person',
    4 => 'Create a book',
    5 => 'Create a rental',
    6 => 'List rentals for a person',
    7 => 'Quit'
  }
  menu.each do |index, value|
    puts "#{index}. #{value}"
    puts 'Select an option: '
  end
  menu
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
