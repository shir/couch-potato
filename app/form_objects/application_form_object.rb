# frozen_string_literal: true

class ApplicationFormObject
  include ActiveModel::Model

  private

  def promote_errors(child_errors)
    child_errors.each do |attribute, message|
      errors.add(attribute, message)
    end
  end
end
