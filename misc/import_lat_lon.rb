require 'pg'
require 'pp'
require 'csv'

CONN = PGconn.connect(
  :host => ENV['PG_HOST'],
  :port => ENV['PG_PORT'], 
  :user => ENV['PG_USER'], 
  :password => ENV['PG_PASS'], 
  :dbname => ENV['PG_DBNAME']
)
CONN.prepare('insertStmt', 'INSERT INTO business_license_loc (business_license_info_id, lat, lon, earth_pos) VALUES ($1, $2, $3, ll_to_earth($2, $3) )')

def data
  CSV.foreach("with_lat_lon.csv", :headers => true) do |line|
    yield line
  end
end

def insert_record(bus_address, lat, lon)
  if bus_address.nil? or bus_address.empty?
    puts "No business address"
    return
  end
  rs = CONN.exec("SELECT id from business_license_info WHERE bus_address = '#{bus_address}'")
  fk = nil
  if rs
    puts "Got #{rs[0]['id']}"
    fk = rs[0]['id']
  end
  if fk.nil?
    puts "Couldn't find a matching record!"
    return
  end
  CONN.exec_prepared('insertStmt', [ fk, lat, lon ] )
end

linecount=0
data do |d|
  d.inspect
	linecount += 1
	insert_record(d["Column 1"], d["lat"].to_f, d["lon"].to_f)
end
puts "#{linecount} total lines"

#["STRNO", "STRDIR", "STRNAME", "STRTYPE", "SUITE_NUM", "BUS_NAME", "OWNER1", "OWNER2", "AREA_CODE", "PHONE_NUM", "WARD", "MAIL_ADDR", "MAIL_CITY", "MAIL_ZIP", "INACTIV", "INACDT", "OWNER_TYPE", "CORP_NAME", "TITLE1", "TITLE2", "BUS_TYPE", "NAICS", "CLV_MJBL", "HEN_MJBL", "NLV_MJBL", "CC_MJBL", "CAT_DESC", "STATUS", "BUS_ADDRESS", "ZIP", "LIC_NUM"]
  # lat float8,
  # lon float8,
  # earth_pos earth,
