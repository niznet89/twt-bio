require 'eth'
require "open-uri"
require "nokogiri"
require 'net/http'
require "onebox"

class UsersController < ApplicationController
  helper_method :onebox_preview

  def new
    @user = User.new
    @session = Session.new
  end

  def homepage
    @session = Session.new
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
    @widget = Widget.find_by(user_id: @user.id)
  end

  def update
    @user = current_user
    if params[:user]
      @user.photo = user_params[:photo]
      @user.save
      redirect_to edit_user_path(@user), notice: "Your profile picture was succesfully updated!"
    else
      redirect_to edit_user_path(@user), notice: "Please include an image."
    end
  end

  def edit

    @user = User.find_by(username: params[:id])
    if logged_in? && @user.eth_address == session["eth_address"]
      @user = User.find(session[:user_id])
      @mirror = mirror_scraping(session[:eth_checksum])
      @project = Project.new
      @widget = Widget.find_by(user_id: @user.id)
      @social = Social.find_by(user_id: @user.id)
      url = "https://mirror.xyz/tenzinr.eth"
      @preview = Onebox.preview(url)

    else
      redirect_to root_path, notice: "Please sign in or sign up with your Metamask wallet"
    end
  end

  def onebox_preview(url)
    Onebox.preview(url)
  end

  private

  def mirror_scraping(username)
    eth_address = username
    uri = URI.parse("https://mirror.xyz/0x76AA1C6Ca91f05201A2B270423Be455B5F6316E0")
    uri_1 = URI.parse("https://mirror.xyz/#{eth_address}")

    response = Net::HTTP.get_response(uri_1)

    if response.class == Net::HTTPPermanentRedirect

    end

    if response.class != Net::HTTPNotFound
      if response.class == Net::HTTPPermanentRedirect
        final_url = "https://" + uri.host + response.body
      else
        final_url = "https://mirror.xyz/#{eth_address}"
      end

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

  def user_params
    params.require(:user).permit(:username, :eth_address, :eth_checksum, :photo)
  end
end
