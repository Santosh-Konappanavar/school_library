require_relative 'person'
require_relative 'classroom'
require_relative 'book'
require_relative 'rental'
require_relative 'student'
require_relative 'teacher'

def all_books(books)
  puts 'List of books:'
  puts
  books.each_with_index do |book, index|
    puts "#{index + 1}. Title: #{book.title}, Author: #{book.author}"
    puts
  end
end

def all_people(people)
  puts 'List of people:'
  puts
  people.each_with_index do |person, index|
    puts "#{index + 1}. Name: #{person.name}, ID: #{person.id}"
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
  puts 'List of rentals:'
  puts
  rentals.each_with_index do |rental, index|
    rental_info(rental, index)
  end
end

def rental_info(rental, index)
  book_info = "Book: #{rental.book.title} by #{rental.book.author}"
  person_info = "Person: #{rental.person.name}"
  date_info = "Date: #{rental.date}"
  puts "#{index + 1}. #{book_info} - #{person_info} - #{date_info}"
  puts
end

def quit
  puts 'bye!'
end