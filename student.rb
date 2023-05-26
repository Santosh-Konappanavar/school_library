require_relative 'person'

class Student < Person
  attr_reader :classroom
  attr_accessor :date

  def initialize(age, classroom, parent_permission: true, name: 'Unknown', date: 'Unknown')
    super(age, parent_permission, name)
    @date = date
    self.classroom = classroom
  end

  def play_hooky
    '¯\(ツ)/¯'
  end

  def classroom=(classroom)
    @classroom = classroom
    classroom.students.push(self) unless classroom.students.include?(self)
  end
end
