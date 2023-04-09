# frozen_string_literal: true

class Patient < ApplicationRecord
  belongs_to :user

  has_many :diagnostics
  has_many :consultations
  has_many :access_controls

  validates :name, :last_name, presence: true
  validates :rg, uniqueness: { allow_blank: true }
  validates :cpf, cpf: true, uniqueness: { allow_blank: true }
  validates :email, email: true, uniqueness: { allow_blank: true }

  def full_name
    "#{name} #{last_name}"
  end
end
