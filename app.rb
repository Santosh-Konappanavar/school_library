require 'json'
require_relative 'person'
require_relative 'classroom'
require_relative 'book'
require_relative 'rental'
require_relative 'student'
require_relative 'teacher'

BOOKS_FILE = 'books.json'.freeze
PEOPLE_FILE = 'people.json'.freeze
RENTALS_FILE = 'rentals.json'.freeze

def save_data(data, file_path)
  File.write(file_path, JSON.generate(data))
  puts "Data saved to #{file_path}!"
end

def load_data(file_path)
  return [] unless File.exist?(file_path)

  file_data = File.read(file_path)
  json_data = JSON.parse(file_data)

  case file_path
  when BOOKS_FILE
    load_books(json_data)
  when PEOPLE_FILE
    load_people(json_data)
  when RENTALS_FILE
    load_rentals(json_data)
  end
end

def load_books(json_data)
  json_data.map.with_index do |book_data, index|
    Book.new(book_data['title'], book_data['author'], index + 1)
  end
end

def load_people(json_data)
  json_data.map.with_index do |person_data, index|
    if person_data['classroom'].nil?
      Teacher.new(person_data['age'], person_data['specialization'], name: person_data['name'], index: index + 1)
    else
      classroom = Classroom.new(person_data['classroom'])
      Student.new(
        person_data['age'],
        classroom,
        parent_permission: person_data['parent_permission'],
        name: person_data['name'],
        index: index + 1
      )
    end
  end
end

def load_rentals(json_data)
  json_data.map.with_index do |rental_data, _index|
    book_data = rental_data['book']
    book = Book.new(book_data['title'], book_data['author'], book_data['index'])
    person_data = rental_data['person']
    person = Person.new(person_data['age'], person_data['parent_permission'], person_data['name'])
    Rental.new(rental_data['date'], person, book)
  end
end

def all_books(books)
  puts 'List of books:'
  puts
  books.each_with_index do |book, index|
    title = book.title
    author = book.author
    puts "#{index + 1}. Title: #{title}, Author: #{author}"
    puts
  end
end

def all_people(people)
  puts 'List of people:'
  puts
  people.each_with_index do |person, index|
    role = person.is_a?(Student) ? 'Student' : 'Teacher'
    if person.is_a?(Student)
      puts "#{index + 1}. #{role}: #{person.name}, Age: #{person.age}, ID: #{person.id}, Date: #{person.date}"
    elsif person.is_a?(Teacher)
      puts "#{index + 1}. #{role}: #{person.name}, Age: #{person.age}, ID: #{person.id}"
    else
      puts "#{index + 1}. #{role}: #{person}"
    end
    puts
  end
end

def create_person(people)
  puts 'Select person type:'
  puts '1. Student'
  puts '2. Teacher'
  print 'Choice: '
  type = gets.chomp.to_i

  case type
  when 1
    create_student(people)
  when 2
    create_teacher(people)
  else
    puts 'Invalid option!'
  end
end

def create_student(people)
  print 'Age: '
  age = gets.chomp.to_i
  print 'Classroom: '
  classroom_name = gets.chomp
  print 'Name: '
  name = gets.chomp
  print 'Has parent permission? (Y/N): '
  permission = gets.chomp == 'Y'

  classroom = Classroom.new(classroom_name)

  person = Student.new(age, classroom, parent_permission: permission, name: name)
  people.push(person)
  puts 'Person created successfully!'
  puts
end

def create_teacher(people)
  print 'Age: '
  age = gets.chomp.to_i
  print 'Specialization: '
  specialization = gets.chomp
  print 'Name: '
  name = gets.chomp
  person = Teacher.new(age, specialization, name: name)
  people.push(person)
  puts 'Person created successfully!'
  puts
end

def create_book(books)
  print 'Title: '
  title = gets.chomp
  print 'Author: '
  author = gets.chomp
  books.push(Book.new(title, author))
  puts 'Book created successfully!'
  puts
end

def create_rental(people, books, rentals)
  selectedbook = selectbook(books)
  selectedperson = selectperson(people)
  return unless selectedbook && selectedperson

  print 'Date: '
  date = gets.chomp
  rental_entry(date, selectedbook, selectedperson, rentals)
end

def selectbook(books)
  puts 'Select a book from the following list by number'
  all_books(books)
  print 'Book number: '
  book_index = gets.chomp.to_i

  selectedbook = books[book_index - 1]

  if selectedbook.nil?
    puts 'Invalid book number!'
    return nil
  end

  selectedbook
end

def selectperson(people)
  puts 'Select a person from the following list by number (not ID) or create a new person'
  all_people(people)
  print 'Person number: '
  person_index = gets.chomp.to_i
  selectedperson = people[person_index - 1]

  if selectedperson.nil?
    puts 'Invalid person number!'
    return nil
  end

  selectedperson
end

def rental_entry(date, selectedbook, selectedperson, rentals)
  rentals.push(Rental.new(date, selectedperson, selectedbook))
  puts 'Rental created successfully!'
  puts
end

def list_rentals(rentals)
  puts 'Enter the ID of the person:'
  print 'Person ID: '
  person_id = gets.chomp.to_i

  filtered_rentals = rentals.select { |rental| rental.person.id == person_id }

  puts 'List of rentals:'
  puts
  filtered_rentals.each_with_index do |rental, index|
    rental_info(rental, index)
  end
end

def rental_info(rental, index)
  book_info = "Book: #{rental.book.title} by #{rental.book.author}"
  person_info = "Person: #{rental.person.name}"
  date_info = "Date: #{rental.date}"
  puts "#{index + 1}.  #{date_info} - #{book_info} - #{person_info}"
  puts
end

def quit(books, people, rentals)
  save_data(books, BOOKS_FILE)
  save_data(people, PEOPLE_FILE)
  save_data(rentals, RENTALS_FILE)
  puts 'Thanks for using this App!'
end
