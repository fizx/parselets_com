require 'cgi'
require 'openssl'
require 'base64'
require 'open-uri'
require "digest/md5"
require "fileutils"

class Thumbnail < ActiveRecord::Base
  
  before_create :download
  DEFAULT_PATH = "/images/spacer.gif"
  
  def self.path_for(url)
    find_or_create_by_url(url).path
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

    # begin
      doc = open(azon_url).read
    # rescue
    #   return nil
    # end

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
    File.join(RAILS_ROOT, "public", path)
  end
  
  def path
    url ? 
      ("/thumbs/" + Digest::MD5.hexdigest(url)[0..6].scan(/.{2}/).join("/") + ".jpg") :
      DEFAULT_PATH
  end
end






