class Api::V1::UsersController < ApiController

  def index
    render json: nil
  end

  # creates a public API that allows fetching the user nonce by address
  def show
    user = nil
    response = nil

    # checks the parameter is a valid eth address
    params_address = Eth::Address.new(params[:id])
    if params_address.valid?
      # finds user by valid eth address (downcase to prevent checksum mismatches)
      user = User.find_by(eth_address: params[:id].downcase)
    end

     # do not expose full user object; just the nonce
    if user && user.id > 0
      response = [eth_nonce: user.eth_nonce]
    end

    render json: response
  end

end
