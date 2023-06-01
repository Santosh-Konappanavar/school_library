require_relative 'app'

def main
  books = load_data(BOOKS_FILE) || []
  people = load_data(PEOPLE_FILE) || []
  rentals = load_data(RENTALS_FILE) || []

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
  end
  puts 'Select an option: ' # Move this line outside the loop
end

def handler(option, books, people, rentals)
  optionactions = {
    1 => -> { all_books(books) },
    2 => -> { all_people(people) },
    3 => -> { create_person(people) },
    4 => -> { create_book(books) },
    5 => -> { create_rental(people, books, rentals) },
    6 => -> { list_rentals(rentals) },
    7 => -> { quit(books, people, rentals) }
  }

  action = optionactions[option]
  if action
    action.call
  else
    puts 'Invalid option!'
  end
end

main
