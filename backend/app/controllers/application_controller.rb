class ApplicationController < ActionController::API
  before_action :authorize_request

  private

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    decoded = JsonWebToken.decode(header)
    @current_user = User.find_by(id: decoded[:user_id]) if decoded
    return render json: { errors: ['Invalid or missing token'] }, status: :unauthorized unless @current_user
  end
end
