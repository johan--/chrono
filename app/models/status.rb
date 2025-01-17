class Status < ActiveRecord::Base

  attr_accessible :message,
                  :is_clock_out

  belongs_to :user

  def ended_at
    if self.next_status.present?
      self.next_status.created_at
    else
      Time.zone.now
    end
  end

  def duration_in_seconds
    self.ended_at - self.created_at
  end

  def duration_in_minutes
    duration_in_minutes = duration_in_seconds / 1.minute
  end

  def duration_in_hours(rounded_to = 15.0)
    hours = (duration_in_minutes / 60).floor
    round_quantity =  ((duration_in_minutes % 60) / rounded_to).round
    hours + round_quantity * (rounded_to / 60.0)
  end

  def previous_status
    self.user.statuses.where('created_at < ?', self.created_at).order('created_at DESC').first
  end

  def next_status
    self.user.statuses.where('created_at > ?', self.created_at).order('created_at ASC').first
  end

  def current?
    next_status.nil?
  end

end
