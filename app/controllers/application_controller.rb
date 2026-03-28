class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  skip_before_action :verify_authenticity_token

  rescue_from ActionController::RoutingError, with: :render_404

  private

    def render_404
      respond_to do |format|
        format.html { render "#{Rails.root}/public/404.html", status: 404 }
        format.json { render json: { status: 404, message: "Page Not Found" } }
      end
    end
end
