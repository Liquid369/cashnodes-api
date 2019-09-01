require 'bundler/setup'
require 'yajl'
require 'rack/cors'
require 'sinatra'

require_relative 'lib/snapshots_list'
require_relative 'lib/get_snapshot'
require_relative 'lib/get_version'
require_relative 'lib/version_list'

configure do
  set :bind, '0.0.0.0'
end

use Rack::Cors do
  allow do
    origins '*'
    resource '*', :headers => :any, :methods => [:get, :options]
  end
end

disable :session
disable :strict_paths

get '/snapshots' do
  page = (params[:page] || 1).to_i
  snapshots = SnapshotsList.call(page)
  meta = snapshots[:meta]
  if meta[:next]
    meta[:next_url] = url("/snapshots?page=#{meta[:next]}")
  end
  if meta[:prev]
    meta[:prev_url] = url("/snapshots?page=#{meta[:prev]}")
  end
  content_type :json
  logger.debug("returning data for page=#{page}: #{snapshots.size} snapshots")
  [200, Yajl::Encoder.encode(snapshots)]
end

get '/snapshots/:timestamp' do
  snapshot_path = GetSnapshot.call(params[:timestamp], logger)
  if snapshot_path.nil?
    logger.info("snapshot #{params[:timestamp]} not found")
    return [404, Yajl::Encoder.encode({error: 'snapshot not found'})]
  end

  content_type:json
  logger.debug("returning data for snapshot #{params[:timestamp]}: #{snapshot_path}")
  send_file(snapshot_path)
end

get '/version' do
  page = (params[:page] || 1).to_i
  version = VersionList.call(page)
  meta = version[:meta]
  if meta[:next]
    meta[:next_url] = url("/version?page=#{meta[:next]}")
  end
  if meta[:prev]
    meta[:prev_url] = url("/version?page=#{meta[:prev]}")
  end
  content_type :json
  logger.debug("returning data for page=#{page}: #{version.size} version snapshots")
  [200, Yajl::Encoder.encode(version)]
end

get '/version/:timestamp' do
  version_path = GetVersion.call(params[:timestamp], logger)
  if version_path.nil?
    logger.info("version snapshot #{params[:timestamp]} not found")
    return [404, Yajl::Encoder.encode({error: 'version snapshot not found'})]
  end

  content_type:json
  logger.debug("returning data for snapshot #{params[:timestamp]}: #{version_path}")
  send_file(version_path)
end

