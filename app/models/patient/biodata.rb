# frozen_string_literal: true

module Patient::Biodata
  extend ActiveSupport::Concern

  included do
    def biodatum
      biodata.last
    end

    def biodata
      exams.order(date: :desc).filter_map(&:biodatum)
    end
  end
end
