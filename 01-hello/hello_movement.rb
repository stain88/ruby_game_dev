require 'gosu'

class GameWindow < Gosu::Window
  def initialize(width=320, height=240, fullscreen=false)
    super
    self.caption = 'Hello Movement'
    @x = @y = 10
    @draws = 0
    @buttons_down = 0
  end

  def update
    @x -= 1 if button_down?(Gosu::KbLeft) || button_down?(Gosu::KbA)
    @x += 1 if button_down?(Gosu::KbRight) || button_down?(Gosu::KbD)
    @y -= 1 if button_down?(Gosu::KbUp) || button_down?(Gosu::KbW)
    @y += 1 if button_down?(Gosu::KbDown) || button_down?(Gosu::KbS)
  end

  def button_down(id)
    close if id == Gosu::KbEscape
    @buttons_down += 1
  end

  def button_up(id)
    @buttons_down -= 1
  end

  def needs_redraw?
    @draws == 0 || @buttons_down > 0
  end

  def draw
    @draws += 1
    @message = Gosu::Image.from_text(self, info, Gosu.default_font_name, 30)
    @message.draw(@x, @y, 0)
  end

  private

  def info
    "[x:#{@x};y:#{@y};draws:#{@draws}]"
  end
end

window = GameWindow.new
window.show
