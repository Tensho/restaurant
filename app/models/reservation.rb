class Reservation < ActiveRecord::Base
  validates_each :table_number do |record, attr, value|
    timetable = where(table_number: value).pluck(:start_time, :end_time)

    timetable.each do |time_interval|
      if record.overlap? *time_interval
        record.errors.add(attr, "time interval overlaps: #{ time_interval[0].localtime }..#{ time_interval[1].localtime }")
      end
    end
  end

  def overlap?(s, e)
    start_time.between?(s, e) || end_time.between?(s, e)
  end
end
