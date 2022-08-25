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

  def home
    @session = Session.new
  end

  def create
    @user = User.new(user_params)
    @session = Session.new
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

            redirect_to root_path, notice: "Successfully created an account, you may now log in."
          else
            flash[:error] = "You have already signed up."
            render :new
          end
        end
      end
    end
  end

  def show
    @user = User.find_by(username: params[:id])
    # @user = User.find(session[:user_id])
    if @user
      @mirror = mirror_scraping(@user.eth_checksum)
      @widget = Widget.find_by(user_id: @user.id)
      @session = Session.new
      @social = Social.find_by(user_id: @user.id)

    else
      render :file => "#{Rails.root}/public/404.html", layout: false, status: :not_found
    end

  end

  def update
    @user = current_user
    if params[:user]
      @user.photo = user_params[:photo]
      @user.description = user_params[:description]
      @user.save
      redirect_to edit_user_path(@user), notice: "✔ Your profile picture and bio were succesfully updated!"
    else
      redirect_to edit_user_path(@user), notice: "Please include an image."
    end
  end

  def edit

    @user = User.find_by(username: params[:id])
    if logged_in? && @user.eth_address == session["eth_address"]
      @session = Session.new
      @user = User.find(session[:user_id])
      @mirror = mirror_scraping(session[:eth_checksum])
      @project = Project.new
      @widget = Widget.find_by(user_id: @user.id)
      @social = Social.find_by(user_id: @user.id)
      url = "https://mirror.xyz/tenzinr.eth/3hK0WRbuJI5CoxQfyEhlBdWLRFYUXaM-VOYGjo7_qOA"
      @preview = Onebox.preview(url)

    else
      render :home
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

    # if response.class == Net::HTTPPermanentRedirect end

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

      html_doc.search("._1sjywpl0._1sjywpl1.bc5nciih.bc5ncisw.bc5nci4s9.bc5nci451").each_with_index do |element, index|
        url_hash[:url].append("https://mirror.xyz#{element.children[1].children[0].attributes["href"].value}")
        url_hash[:title].append(element.children[1].children[0].children.children[0].text)
      end
      url_hash
    end
  end

  def user_params
    params.require(:user).permit(:username, :description, :eth_address, :eth_checksum, :photo)
  end
end
