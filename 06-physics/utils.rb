module Utils

  def self.media_path(file)
    File.join(File.dirname(File.dirname(__FILE__)), 'media', file)
  end

  def self.track_update_interval
    now = Gosu.milliseconds
    @update_interval = (now - (@last_update ||= 0)).to_f
    @last_update = now
  end

  def self.update_interval
    @update_interval ||= $window.update_interval
  end

  def self.adjust_speed(speed)
    speed * update_interval / 33.33
  end

  def self.button_down?(button)
    @buttons ||= {}
    now = Gosu.milliseconds
    now = now - (now % 150)
    if $window.button_down?(button)
      @buttons[button] = now
      true
    elsif @buttons[button]
      if now == @buttons[button]
        true
      else
        @buttons.delete(button)
        false
      end
    end
  end

  def self.rotate(angle, around_x, around_y, *points)
    result = []
    angle = angle * Math::PI / 180.0
    points.each_slice(2) do |x, y|
      r_x = Math.cos(angle) * (around_x - x) - Math.sin(angle) * (around_y - y) + around_x
      r_y = Math.sin(angle) * (around_x - x) + Math.cos(angle) * (around_y - y) + around_y
      result << r_x
      result << r_y
    end
    result
  end

  def self.point_in_poly(test_x, test_y, *poly)
    n_vert = poly.size / 2 # Number of vertices in poly
    vert_x = []
    vert_y = []
    poly.each_slice(2) do |x, y|
      vert_x << x
      vert_y << y
    end
    inside = false
    j = n_vert - 1
    (0..n_vert - 1).each do |i|
      if (((vert_y[i] > test_y) != (vert_y[j] > test_y)) && (test_x < (vert_x[j] - vert_x[i]) * (test_y - vert_y[i]) / (vert_y[j] - vert_y[i]) + vert_x[i]))
        inside = !inside
      end
      j = i
    end
    inside
  end

end
