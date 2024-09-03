# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery

  def params
    request.parameters
  end
end
