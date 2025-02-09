# frozen_string_literal: true

class Exam < ApplicationRecord
  include Biodata

  enum :classification, { hemogram: 0, cholesterol_and_triglycerides: 1, urea_and_creatinine: 2, urine: 3, faeces: 4, eletrocardiogram: 5, other: 6 }

  belongs_to :patient

  has_one :biodatum

  has_one_attached :result

  validates :classification, :date, :local, presence: true
end
