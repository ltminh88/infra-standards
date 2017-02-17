class AlivesController < ApplicationController
  def show
    render status: 200, text: "It works!"
  end
end
