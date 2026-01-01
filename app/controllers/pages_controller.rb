class PagesController < ApplicationController
  def home
    races = Race.upcoming
                .includes(:race_distances, featured_image_attachment: :blob)
                .order(:start_time)

    @races_by_month = races.group_by { |race| race.start_time.beginning_of_month }
  end
end
