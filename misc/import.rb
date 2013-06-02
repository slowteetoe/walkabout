require 'pg'
require 'pp'
require 'csv'

CONN = PGconn.connect("localhost", 5432, "", "", "tomorrow_today")
CONN.prepare('insertStmt', 'INSERT INTO business_license_info ( status, business_name, business_type, area_code, phone_number, category, bus_address, zipcode) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)')

def data
  CSV.foreach("Business-Licenses.csv", :headers => true) do |line|
    yield line
  end
end

def insert_record(status, bus_name, bus_type, area_code, phone_num, cat_desc, bus_address, zip)
  CONN.exec_prepared('insertStmt', [ status, bus_name, bus_type, area_code, phone_num, cat_desc, bus_address, zip ] )
  puts "Inserted."
end

linecount=0
data do |d|
	linecount += 1
	insert_record(d["STATUS"], d["BUS_NAME"], d["BUS_TYPE"], d["AREA_CODE"], d["PHONE_NUM"], d["CAT_DESC"], d["BUS_ADDRESS"], d["ZIP"])
end
puts "#{linecount} total lines"

#["STRNO", "STRDIR", "STRNAME", "STRTYPE", "SUITE_NUM", "BUS_NAME", "OWNER1", "OWNER2", "AREA_CODE", "PHONE_NUM", "WARD", "MAIL_ADDR", "MAIL_CITY", "MAIL_ZIP", "INACTIV", "INACDT", "OWNER_TYPE", "CORP_NAME", "TITLE1", "TITLE2", "BUS_TYPE", "NAICS", "CLV_MJBL", "HEN_MJBL", "NLV_MJBL", "CC_MJBL", "CAT_DESC", "STATUS", "BUS_ADDRESS", "ZIP", "LIC_NUM"]

# or: CONN = PGconn.open('dbname=test1')
#rs = CONN.exec("select * from business_license_info;")
#pp rs.fields
#   status varchar(64),
  # business_name varchar(128),
  # business_type varchar(64),
  # area_code varchar(3),
  # phone_number varchar(7),
  # category varchar(64),
  # bus_address varchar(128),
  # zipcode varchar(9)