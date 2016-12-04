class ChartsController < ApplicationController
  def index
    @burnup = Burnup.new
  end

  def create
    @burnup = Burnup.new filter_params
    render :index
  end

  def filter_params
    params.require(:burnup).permit(:throughput_projection, :total_cards, :timebox_cicles, :input_real_data)
  end
end

class Burnup
  include ::Virtus.model, ActiveModel::Model

  attribute :throughput_projection, Integer, default: 3
  attribute :total_cards, Integer, default: 100
  attribute :timebox_cicles, Integer, default: 24
  attribute :input_real_data, String, default: '0 0 2 5 6'

  def linear_projection
    total_cicles.times.each_with_index.map{|x,i| [ "week-#{i+1}", x + i + throughput_projection] }
  end

  def real_data
    points = []
    format_input.each_with_index.reduce(0) do |sum, (value, i)|
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
end
