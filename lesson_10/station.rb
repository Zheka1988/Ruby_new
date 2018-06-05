require_relative 'instance_counter'
require_relative 'validation'
require_relative 'accessors'
class Station
  extend Accessors
  include Validation
  include InstanceCounter
  attr_reader :trains

  NAME = /\A[а-яa-z0-9]{3,10}\Z/i
  @@stations = []

  attr_accessor_with_history :a, :b, :c
  strong_attr_accessor :color, String

  validate :name, :presence
  validate :name, :format, NAME
  validate :name, :type, String

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
    validate!
    @@stations << self
    register_instance
  end

  def all_trains
    @trains.each { |train| yield(train) }
  end

  def train_arrived(train)
    raise 'Не существует такого поезда!' unless train.class < Train
    raise 'Поезд стоит на этой станции!' if @trains.find do |tr|
      tr if tr.number == train.number
    end
    @trains << train
  rescue StandardError => e
    puts e.message
    false
  end

  def count_by_type(type)
    @trains.count { |train| train.type == type }
  end

  def train_left(train)
    @trains.delete(train)
  end
end
