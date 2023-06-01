class Classroom
  attr_accessor :label, :students

  def initialize(label)
    @label = label
    @students = []
  end

  def add_student(student)
    student.classroom = self
    @students << student
  end

  def to_json(*_args)
    {
      classroom: @classroom&.label
    }.to_json
  end
end
