class ChartsController < ApplicationController
  def index
    @burnup = Burnup.new
  end
end

class Burnup
  attr_accessor :throughput_projection, :total_cards,  :timebox_cicles

  def initialize
    @throughput_projection = 4
    @total_cards = 100
    @timebox_cicles = 17
  end

  def linear_projection
    21.times.each_with_index.map{|x,i| [ "week-#{i}", x + i + throughput_projection] }
  end

  def real_data
    (0..10).to_a.sample(40).each_with_index.map{|x,i| ["week-#{i+1}", x]}
  end

  def timebox
    [ ["week-#{timebox_cicles}", 60] ]
  end

  def total_cicles
    total_cards / throughput_projection
  end
end
