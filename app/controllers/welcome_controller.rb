class WelcomeController < ApplicationController
  def index
    render json: "Welcome on board, Bos!"
  end
end
