require "eth"
require "time"

class SessionsController < ApplicationController

  def new
    @session = Session.new
  end

  def create
    # user = User.find(eth_address: params[:eth_address])
    user = User.find_by(eth_address: session_params[:eth_address].downcase)
    if user.present?
      if session_params[:eth_signature]
        # the message is random and has to be signed in the ethereum wallet
        message = session_params[:eth_message]
        signature = session_params[:eth_signature]
        # note, we use the user address and nonce from our database, not from the form
        user_address = user.eth_address
        user_nonce = user.eth_nonce
        # we embedded the time of the request in the signed message and make sure
        # it's not older than 5 minutes. expired signatures will be rejected.
        custom_title, request_time, signed_nonce = message.split(",")
        request_time = Time.at(request_time.to_f / 1000.0)
        expiry_time = request_time + 300
        # also make sure the parsed request_time is sane
        # (not nil, not 0, not off by orders of magnitude)
        sane_checkpoint = Time.now - 30.day
        if (request_time > sane_checkpoint) && (Time.now < expiry_time) && (signed_nonce == user_nonce)
          # recover address from signature
          signature_pubkey = Eth::Signature.personal_recover(message, signature)
          signature_address = Eth::Util.public_key_to_address(signature_pubkey)
          # if the recovered address matches the user address on record, proceed
          # (uses downcase to ignore checksum mismatch)
          if user_address.downcase.eql? signature_address.to_s.downcase
            # if this is true, the user is cryptographically authenticated!
            session[:user_id] = user.id
            # Note: the eth_address needs to be pulled from params as the HTTP routing is case sensitive
            session[:eth_address] = session_params[:eth_address].downcase
            session[:eth_checksum] = session_params[:eth_address]
            user.eth_nonce = SecureRandom.uuid
            redirect_to edit_user_path(user), notice: "Logged in successfully!"
          end
        end
      end
    end
  end

  private

  def session_params
    params.require(:session).permit(:eth_message, :eth_address, :eth_signature)
  end

end
