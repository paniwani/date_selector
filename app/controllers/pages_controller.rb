class PagesController < ApplicationController
  def home
    dws = JSON.parse(File.read('times.json'))["result"]

    @times = []
    dws.each do |hour_group, hsel|
      hsel.each do |dw, dsel|
        @times += dsel
      end
    end

    @times.map! do |time_range|
      start_time = CGI::unescape time_range["start"]
      end_time   = CGI::unescape time_range["end"]

      start_time = Chronic.parse start_time
      end_time   = Chronic.parse end_time

      [start_time, end_time]
    end

    @times.sort_by! { |time_range| time_range[0] }

    @times.map! do |time_range|
      start_time = time_range[0]
      end_time = time_range[1]

      start_time = start_time.strftime("%b %e %l %P")
      end_time = end_time.strftime("%l %P")

      "#{start_time} - #{end_time}"
    end
  end
end