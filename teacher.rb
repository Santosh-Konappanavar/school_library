require_relative 'person'

class Teacher < Person
  attr_accessor :specialization, :index

  def initialize(age, specialization, parent_permission: true, name: 'Unknown', index: 0)
    super(age, parent_permission, name)
    @specialization = specialization
    @index = index
  end

  def can_use_services?
    true
  end

  def to_json(*_args)
    {
      age: @age,
      specialization: @specialization,
      name: @name,
      index: @index
    }.to_json
  end
end
