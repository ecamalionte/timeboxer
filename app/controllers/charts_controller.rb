class ChartsController < ApplicationController
  def index
    @burnup = Burnup.new
  end

  def create
    @burnup = Burnup.new filter_params
    render :index
  end

  def filter_params
    params.require(:burnup).permit(:throughput_projection, :total_cards, :timebox_cicles, :input_real_data, :algorithm)
  end
end

class Burnup
  include ::Virtus.model, ActiveModel::Model

  attribute :throughput_projection, Integer, default: 3
  attribute :total_cards, Integer, default: 100
  attribute :timebox_cicles, Integer, default: 24
  attribute :input_real_data, String, default: '0 0 2 5 6'
  attribute :algorithm, String, default: 'none'

  def linear_projection
    n = total_cards
    points = []
    while (n > 0)
      points = points + [throughput_projection]
      n -= throughput_projection
    end
    accumulated_format points
  end

  def real_data
    accumulated_format format_input
  end

  def repetition_projection
    chunck_of_cards = format_input.sum
    repetitions = total_cards / chunck_of_cards
    mod = total_cards % chunck_of_cards
    repetitions += 1 if mod != 0
    points = []
    repetitions.times do
      points = points + format_input
    end
    accumulated_format points
  end

  def random_projection
    n = total_cards
    list = format_input
    points = []
    while (n > 0)
      item = list.sample
      points = points + [ item ]
      n -= item
    end
    accumulated_format points
  end

  def accumulated_format list
    points = []
    list.each_with_index.reduce(0) do |sum, (value, i)|
      points << ["week-#{i+1}", sum + value]
      sum + value
    end
    points
  end

  def total_cicles
    total_cards / throughput_projection
  end

  def format_input
    input_real_data ? input_real_data.split(' ').map(&:to_i) : []
  end

  def build_data
    data = [ { name: "Linear Prediction", data: linear_projection },
             { name: "Real World", data: real_data } ]

    case algorithm
    when 'repetition'
      data << { name: "Repetition Prediction", data: repetition_projection }
    when 'random'
      data << { name: "Random Prediction", data: random_projection }
    end
    data
  end

  def max_of_weeks
    charts = build_data
    max = 0
    charts.each do |chart|
      current = chart[:data].count
      max = current if current > max
    end
    max
  end
end
