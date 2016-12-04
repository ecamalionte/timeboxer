class ChartsController < ApplicationController
  def index
    @burnup = Burnup.new #virtus
  end

  def create
    @burnup = Burnup.new filter_params[:throughput_projection],
                         filter_params[:total_cards],
                         filter_params[:timebox_cicles],
                         filter_params[:input_real_data]
    render :index
  end

  def filter_params
    params.require(:burnup).permit(:throughput_projection, :total_cards, :timebox_cicles, :input_real_data)
  end
end

class Burnup
  include ActiveModel::Model
  
  attr_accessor :throughput_projection, :total_cards,  :timebox_cicles, :input_real_data

  def initialize(throughput_projection=3, total_cards=100, timebox_cicles=24, input_real_data="0 0 3 4 5 1 4 5")
    @throughput_projection = throughput_projection ? throughput_projection.to_i : 1
    @total_cards = total_cards ? total_cards.to_i : 100
    @timebox_cicles = timebox_cicles ? timebox_cicles.to_i : 1
    @input_real_data = input_real_data ? input_real_data.split(' ').map(&:to_i) : []
  end

  def linear_projection
    total_cicles.times.each_with_index.map{|x,i| [ "week-#{i+1}", x + i + throughput_projection] }
  end

  def real_data
    points = []
    input_real_data.each_with_index.reduce(0) do |sum, (value, i)|
      points << ["week-#{i+1}", sum + value]
      sum + value
    end
    points
  end

  def total_cicles
    total_cards / throughput_projection
  end
end
