class TankMotionState
  STATE_CHANGE_DELAY = 500

  def initialize(object, vision, gun)
    @object = object
    @vision = vision
    @gun = gun
    @roaming_state = TankRoamingState.new(object, vision)
    @fighting_state = TankFightingState.new(object, vision)
    @fleeing_state = TankFleeingState.new(object, vision, gun)
    @chasing_state = TankChasingState.new(object, vision, gun)
    set_state(@roaming_state)
  end

  def enter
    # Override if necessary
  end

  def change_direction
    # Override
  end

  def wait_time
    # Override and return a number
  end

  def drive_time
    # Override and return a number
  end

  def turn_time
    # Override and return a number
  end

  def update
    choose_state
    @current_state.update
  end

  def set_state(state)
    return unless state
    return if state == @current_state
    @last_state_change = Gosu.milliseconds
    @current_state = state
    state.enter
  end

  def choose_state
    return unless Gosu.milliseconds - (@last_state_change) > STATE_CHANGE_DELAY
    if @gun.target
      if @object.health.health > 40
        if @gun.distance_to_target > BulletPhysics::MAX_DIST
          new_state = @chasing_state
        else
          new_state = @fighting_state
        end
      else
        if @fleeing_state.can_flee?
          new_state = @fleeing_state
        else
          new_state = @fighting_state
        end
      end
    else
      new_state = @roaming_state
    end
    set_state(new_state)
  end

  def wait
    @sub_state = :waiting
    @started_waiting = Gosu.milliseconds
    @will_wait_for = wait_time
    @object.throttle_down = false
  end

  def drive
    @sub_state = :driving
    @started_driving = Gosu.milliseconds
    @will_drive_for = drive_time
    @object.throttle_down = true
  end

  def should_change_direction?
    return true unless @changed_direction_at
    Gosu.milliseconds - @changed_direction_at > @will_keep_direction_for
  end

  def substate_expired?
    now = Gosu.milliseconds
    case @sub_state
    when :waiting
      true if now - @started_waiting > @will_wait_for
    when :driving
      true if now - @started_driving > @will_drive_for
    else
      true
    end
  end

  def on_collision(with)
    @current_state.on_collision(with)
  end

  def on_damage(amount)
    if @current_state == @roaming_state
      set_state(@fighting_state)
    end
  end

end
