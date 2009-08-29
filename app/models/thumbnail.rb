require 'cgi'
require 'openssl'
require 'base64'
require 'open-uri'
require "digest/md5"
require "fileutils"

class Thumbnail < ActiveRecord::Base
  
  before_save :download
  DEFAULT_PATH = "/images/no-thumb.png"
  DEBUG_PATH = "/images/debug_thumbnail.jpg"
  MAX_TRIES = 5
  
  def self.path_for(url)
    "http://open.thumbshots.org/image.aspx?url="+URI::escape(url)
    
    # if !thumbnail_service_ready?
    #   return (RAILS_ENV == 'development') ? DEBUG_PATH : DEFAULT_PATH
    # end
    # 
    # File.exists?(filesystem_path(url)) ? 
    #   relative_path(url) : 
    #   try_url(url)
  end
  
  def self.try_url(url, force = false)
    model = find_or_create_by_url(url)
    
    if !File.exists?(model.filesystem_path) && (force || model.tries.to_i < MAX_TRIES)
      model.download
      model.increment!(:tries)
    end
    
    model.path
  end

  def self.relative_path(url)
    ("/thumbs/" + Digest::MD5.hexdigest(url)[0..6].scan(/.{2}/).join("/") + ".jpg")
  end
  
  def self.filesystem_path(url)
    File.join(RAILS_ROOT, "public", relative_path(url))
  end
  
  def self.thumbnail_service_ready?
    ENV['SECRET_ACCESS_KEY'] && ENV["ACCESS_KEY_ID"]
  end
    
  def download
    access_id = ENV["ACCESS_KEY_ID"]
    secret_id = ENV['SECRET_ACCESS_KEY']
    
    access_id && secret_id || raise("no amazon credentials")

    timestamp = Time.now.gmtime.strftime("%Y-%m-%dT%H:%M:%SZ")
    sig = Base64.encode64(OpenSSL::HMAC::digest(OpenSSL::Digest::Digest.new('SHA1'), secret_id, 'Thumbnail' + timestamp)).strip

    azon_url = "http://ast.amazonaws.com/?Action=Thumbnail&AWSAccessKeyId=" + access_id
    azon_url << "&Signature=" + CGI.escape(sig)
    azon_url << "&Timestamp=" + CGI.escape(timestamp)
    azon_url << "&Url=" +  url
    azon_url << "&Size=Small"

    begin
      Timeout.timeout(2) do 
        doc = open(azon_url).read
      end
    rescue Timeout::Error
      return nil
    end

    m = doc.match(/\<aws:thumbnail[^\>]+exists=\"true\"\>(.+?)\<\//i)

    if m && m[1]
      thumb_url = m[1]
      thumb_url.gsub!(/\&amp;/, '&')
      FileUtils.mkdir_p(File.dirname(filesystem_path))
      File.open(filesystem_path, "w") { |f| f.write open(thumb_url).read }
    else
      puts doc
    end
  end
  
  def filesystem_path
    Thumbnail.filesystem_path(url)
  end

  def path
    File.exists?(filesystem_path) ? 
      Thumbnail.relative_path(url) :
      DEFAULT_PATH
  end
end






