require_relative 'person'

class Student < Person
  attr_reader :classroom
  attr_accessor :date, :index

  def initialize(age, classroom, parent_permission: true, name: 'Unknown', date: 'Unknown', index: 0)
    super(age, parent_permission, name)
    @date = date
    self.classroom = classroom
    @index = index
  end

  def play_hooky
    '¯\(ツ)/¯'
  end

  def classroom=(classroom)
    @classroom = classroom
    classroom.students.push(self) unless classroom.students.include?(self)
  end
  def to_json(*_args)
    {
      age: @age,
      classroom: @classroom&.label,
      parent_permission: @parent_permission,
      name: @name,
      index: @index
    }.to_json
  end
end
