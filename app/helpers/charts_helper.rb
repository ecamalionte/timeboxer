module ChartsHelper
  def calculate_timebox_coordinate(width=800)
    pixels_per_cicle = width / @burnup.total_cicles
    pixels_per_cicle * @burnup.timebox_cicles
  end
end
