require_relative 'Person'
class Student < Person
    def initialize(age, parent_permission = true, name = "Unknown", classroom)
      super(age, parent_permission, name)
      @classroom = classroom
    end
  
    def play_hooky
      "¯\\(ツ)/¯"
    end
  end
  