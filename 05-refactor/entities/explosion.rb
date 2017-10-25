class Explosion < GameObject
  attr_accessor :x, :y

  def initalize(object_pool, x, y)
    super(object_pool)
    @x, @y = x, y
    ExplosionGraphics.new(self)
    ExplosionSounds.play
  end

end
