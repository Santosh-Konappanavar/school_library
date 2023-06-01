require 'json'
require_relative 'person'
require_relative 'classroom'
require_relative 'book'
require_relative 'rental'
require_relative 'student'
require_relative 'teacher'

BOOKS_FILE = 'books.json'
PEOPLE_FILE = 'people.json'
RENTALS_FILE = 'rentals.json'

def save_data(data, file_path)
  File.open(file_path, 'w') do |file|
    file.write(JSON.generate(data))
  end
  puts "Data saved to #{file_path}!"
end


def load_data(file_path)
  return [] unless File.exist?(file_path)

  file_data = File.open(file_path, 'r') { |file| file.read }
  json_data = JSON.parse(file_data)

  if file_path == BOOKS_FILE
    json_data.map.with_index do |book_data, index|
      Book.new(book_data['title'], book_data['author'], index + 1)
    end
  elsif file_path == PEOPLE_FILE
    json_data.map.with_index do |person_data, index|
      if person_data['classroom'].nil?
        Teacher.new(person_data['age'], person_data['specialization'], name: person_data['name'], index: index + 1)
      else
        Student.new(person_data['age'], Classroom.new(person_data['classroom']['classroom&.label']), parent_permission: person_data['parent_permission'], name: person_data['name'], date: person_data['date'], index: index + 1)
      end
    end
  elsif file_path == RENTALS_FILE
    json_data.map.with_index do |rental_data, index|
      book_data = rental_data['book']
      book = Book.new(book_data['title'], book_data['author'], book_data['index'])
      person_data = rental_data['person']
      person = Person.new(person_data['age'], person_data['parent_permission'], person_data['name'])
      Rental.new(rental_data['date'], person, book)
    end
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
