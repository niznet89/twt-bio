require 'eth'
require "open-uri"
require "nokogiri"
require 'net/http'

class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    # only proceed with pretty names

    if @user && @user.username && @user.username.size > 0
      # create random nonce
      @user.eth_nonce = SecureRandom.uuid
      # only proceed with eth address
      if @user.eth_address
        # make sure the eth address is valid
        if Eth::Address.new(@user.eth_address).valid?
          # save to database
          if @user.save
            # if user is created, congratulations, send them to login
            redirect_to edit_user_path(@user), notice: "Successfully created an account, you may now log in."
          else
            render :new
          end
        end
      end
    end
  end

  def show
    @user = User.find_by(username: params[:id])
    @user = User.find(session[:user_id])
    @mirror = mirror_scraping(session[:eth_checksum])
  end

  def edit

    @user = User.find_by(username: params[:id])
    if logged_in? && @user.eth_address == session["eth_address"]
      @user = User.find(session[:user_id])
      @mirror = mirror_scraping(session[:eth_checksum])
      @github = Github.new
    else
      redirect_to root_path, notice: "Please sign in or sign up with your Metamask wallet"
    end
  end

  private

  def mirror_scraping(username)
    eth_address = username
    uri = URI.parse("https://mirror.xyz/0x36781B49A5E29C46c161acF5A42dFea57975e00A")
    uri_1 = URI.parse("https://mirror.xyz/#{eth_address}")

    response = Net::HTTP.get_response(uri_1)
    if response.class != Net::HTTPNotFound
      final_url = "https://" + uri.host + response.body
      test = URI.parse(final_url)

      html_file = URI.open(final_url).read
      html_doc = Nokogiri::HTML(html_file)
      url_hash = { url: [], title: [] }

      html_doc.search(".css-cts56n").each_with_index do |element, index|
        url_hash[:url].append("https://mirror.xyz#{element.children[0].attributes["href"].value}")
        url_hash[:title].append(html_doc.search(".css-1b1esvm").children[index].text)
      end
      url_hash
    end
  end

  def github_profile(username)

  end

  def user_params
    params.require(:user).permit(:username, :eth_address, :eth_checksum)
  end
end
