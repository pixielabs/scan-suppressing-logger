class HomeController < ApplicationController

  def exception
    raise "Testing exception suppressing."
  end
  
end