require 'test_helper'

class ReservationTest < ActiveSupport::TestCase
  def setup
    Reservation.create start_time: Time.new(2014, 05, 21,  9, 0, 0),
                         end_time: Time.new(2014, 05, 21, 12, 0, 0),
                     table_number: 1
    Reservation.create start_time: Time.new(2014, 05, 21, 13, 0, 0),
                         end_time: Time.new(2014, 05, 21, 14, 0, 0),
                     table_number: 1
    Reservation.create start_time: Time.new(2014, 05, 21,  9, 0, 0),
                         end_time: Time.new(2014, 05, 21, 12, 0, 0),
                     table_number: 2
    Reservation.create start_time: Time.new(2014, 05, 21, 15, 0, 0),
                         end_time: Time.new(2014, 05, 21, 18, 0, 0),
                     table_number: 2
  end

  test "should pass validation during not overlapped time interval creation" do
    r = Reservation.create start_time: Time.new(2014, 05, 21, 13, 0, 0),
                             end_time: Time.new(2014, 05, 21, 14, 0, 0),
                         table_number: 2
    assert_equal(r.errors.messages, {})
  end

  test "should fail validation during overlapped (=) time interval creation" do
    r = Reservation.create start_time: Time.new(2014, 05, 21,  9, 0, 0),
                             end_time: Time.new(2014, 05, 21, 12, 0, 0),
                         table_number: 2
    assert_equal r.errors.messages, { table_number: ["time interval overlaps: 2014-05-21 09:00:00 +0300..2014-05-21 12:00:00 +0300"] }
  end

  test "should fail validation during overlapped (<=) time interval creation" do
    r = Reservation.create start_time: Time.new(2014, 05, 21, 8, 0, 0),
                             end_time: Time.new(2014, 05, 21, 9, 0, 0),
                         table_number: 2
    assert_equal r.errors.messages, { table_number: ["time interval overlaps: 2014-05-21 09:00:00 +0300..2014-05-21 12:00:00 +0300"] }
  end

  test "should fail validation during overlapped (>=) time interval creation" do
    r = Reservation.create start_time: Time.new(2014, 05, 21, 12, 0, 0),
                             end_time: Time.new(2014, 05, 21, 13, 0, 0),
                         table_number: 2
    assert_equal r.errors.messages, { table_number: ["time interval overlaps: 2014-05-21 09:00:00 +0300..2014-05-21 12:00:00 +0300"] }
  end

  test "should fail validation during overlapped (<) time interval creation" do
    r = Reservation.create start_time: Time.new(2014, 05, 21,  8, 0, 0),
                             end_time: Time.new(2014, 05, 21, 12, 0, 0),
                         table_number: 2
    assert_equal r.errors.messages, { table_number: ["time interval overlaps: 2014-05-21 09:00:00 +0300..2014-05-21 12:00:00 +0300"] }
  end

  test "should fail validation during overlapped (>) time interval creation" do
    r = Reservation.create start_time: Time.new(2014, 05, 21, 11, 0, 0),
                             end_time: Time.new(2014, 05, 21, 13, 0, 0),
                         table_number: 2
    assert_equal r.errors.messages, { table_number: ["time interval overlaps: 2014-05-21 09:00:00 +0300..2014-05-21 12:00:00 +0300"] }
  end
end
