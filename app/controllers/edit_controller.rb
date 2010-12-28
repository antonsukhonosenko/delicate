require 'net/http'
require 'net/https'
require 'uri'
require 'yaml'
require 'oauth'
require 'pp'

class EditController < ApplicationController

  before_filter :auth, :except => [:login, :logout]
  before_filter :check_xsrf, :except => [:login, :logout, :bundles]

  def login
    if params[:login] && params[:password]
      delicious = WWW::Delicious.new(params[:login], params[:password]);
      if delicious.valid_account?
        session[:login] = params[:login]
        session[:password] = params[:password]

        redirect_to :action => 'bundles'

      else
        flash[:error] = 'Invalid username or password'
      end
    end
  end

  def logout
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "Logged out"
    redirect_to :action => "login"
  end

  def bundles # and tags, for editing

    @tags_cache = @delicious.tags_get

    @autocomplete = "[";

    @tags_cache.each do |t|
      @autocomplete += ("'"+t.name+"', ")
    end

    @autocomplete += "];";

    if !params[:bundle]
      @bundles = @delicious.bundles_all
      @tags = @tags_cache
    else
      @bundles = @delicious.bundles_all
      @bundle = @bundles.find {|b| b.name == params[:bundle]}

      @tags = []

      @bundle.tags.each do |tag|
        @tags << @tags_cache.find{|t| t.name == tag}
      end

      @bundle_param = "bundle="+params[:bundle]
   end
  end

  def create_bundle
    @delicious.bundles_set(params[:bundle], params[:tags].split(" "))
    @bundles = @delicious.bundles_all
  end

  def delete_bundle
    @delicious.bundles_delete(params[:bundle])
    @bundles = @delicious.bundles_all

    render 'create_bundle' #wrongly named, contains list of bundles, refactor on time
  end

  def tag_to_bundle
    @bundles = @delicious.bundles_all
    @bundle = @bundles.find {|b| b.name == params[:bundle]}
    @bundle.tags << params[:tag]
    @delicious.bundles_set(@bundle.name, @bundle.tags)

    @bundles = @delicious.bundles_all

    render 'create_bundle' #wrongly named, contains list of bundles, refactor on time
  end

  def rename_tag

    @delicious.tags_rename(params[:old], params[:new])

    @tags_cache = @delicious.tags_get

    if !params[:bundle]
      @bundles = @delicious.bundles_all
      @tags = @tags_cache
    else
      @bundles = @delicious.bundles_all
      @bundle = @bundles.find {|b| b.name == params[:bundle]}

      @tags = []

      @bundle.tags.each do |tag|
        @tags << @tags_cache.find{|t| t.name == tag}
      end

      @bundle_param = "bundle="+params[:bundle]
   end

    render :partial => 'edit/tags'
  end

  def merge_tags

    @delicious.tags_rename(params[:old], params[:new])

    @tags_cache = @delicious.tags_get

    if !params[:bundle]
      @bundles = @delicious.bundles_all
      @tags = @tags_cache
    else
      @bundles = @delicious.bundles_all
      @bundle = @bundles.find {|b| b.name == params[:bundle]}

      @tags = []

      @bundle.tags.each do |tag|
        @tags << @tags_cache.find{|t| t.name == tag }
      end

      @bundle_param = "bundle="+params[:bundle]
   end

    render :text => @tags.find{|t| t.name == params[:new] }.count
  end


  def delete_tag

    http = Net::HTTP.new("api.del.icio.us", 443)
    http.use_ssl = true
    http.start do |http|
      req = Net::HTTP::Post.new("/v1/tags/delete", {"User-Agent" => "Delicate Better Tag Editor 0.1"})
      req.set_form_data({"tag" => params[:tag]}, ';')
      req.basic_auth(session[:login], session[:password])
      response = http.request(req)
      resp = response.body
    end

    @tags_cache = @delicious.tags_get

    if !params[:bundle]
      @bundles = @delicious.bundles_all
      @tags = @tags_cache
    else
      @bundles = @delicious.bundles_all
      @bundle = @bundles.find {|b| b.name == params[:bundle]}

      @tags = []

      @bundle.tags.each do |tag|
        @tags << @tags_cache.find{|t| t.name == tag}
      end

      @bundle_param = "bundle="+params[:bundle]
   end

   render :partial => 'edit/tags'
  end

private

  def check_xsrf
    if !request.env['HTTP_REFERER']
      render :text => 'No such url found'
      return
    end
  end


  def auth

    @delicious = WWW::Delicious.new(session[:login], session[:password])

    if(!@delicious.valid_account?)
      cookies.delete :auth_token
      reset_session
      flash[:notice] = "Please login first"
      redirect_to :action => "login"
      return
    end
  end

end
