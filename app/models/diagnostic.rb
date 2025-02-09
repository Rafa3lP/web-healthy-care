# frozen_string_literal: true

class Diagnostic < ApplicationRecord
  enum :status, { inactive: 0, active: 1, chronic: 2, acute: 3, remission: 4, terminal: 5, cured: 6 }, default: :active

  belongs_to :disease
  belongs_to :patient

  has_many :treatments

  validates :diagnosed_at, presence: true, date: true
  validates :cured_at, date: true, comparison: { greater_than_or_equal_to: :diagnosed_at, allow_blank: true }
  validates :status, presence: true, uniqueness: { scope: [:disease_id, :patient_id], message: "O paciente já tem essa doença com este mesmo status!" }
end
