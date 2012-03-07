module GoldencobraNewsletter
  class NewslettersController < ApplicationController

    def register

      render :text => params.inspect

    end

  end
end
