require 'sinatra'
require 'pg'
require 'sinatra/json'
require 'data_mapper'
require 'json'
require 'active_support/all'

DataMapper::Logger.new($stdout, :debug)

DataMapper.setup(:default, ENV['DATABASE_URL'] ||  'postgres://tomorrow_today:@127.0.0.1/tomorrow_today')

get '/' do
  erb :index
end

# e.g. http://localhost:4567/activity/36.165611999999996/-115.14102100000001/closest/10
get '/activity/:lat/:lon/closest/:max' do
  content_type :json
  r = repository(:default).adapter.select(
  	"select loc.lat, loc.lon, info.*, earth_distance(earth_pos, ll_to_earth(?, ?)) * 0.000621371192  AS dist_mi from business_license_loc loc JOIN business_license_info info ON info.id = loc.business_license_info_id  where lat <> 0 order by dist_mi asc LIMIT ?",
  	params[:lat],
  	params[:lon],
  	params[:max]
  	)
  r.to_json
end

