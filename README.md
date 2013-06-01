Tomorrow, today
===
This is a hack for the Las Vegas Hack / 2013 National Day of Civic Hacking hackathon.

Ever been curious about what's going on around you?  What businesses are going in?  What businesses are moving out (or aren't current with their business licence)?

This aims to scratch that itch - we'll pull the business licence data from the City of Las Vegas for nearby locations and display it to you.

DB schema for business license data
---
CREATE TABLE business_license_info (
  id serial,
  status varchar(64),
  business_name varchar(128),
  business_type varchar(64),
  area_code varchar(3),
  phone_number varchar(7),
  category varchar(64),
  bus_address varchar(128),
  zipcode varchar(9)
);

ALTER TABLE business_license_info ADD CONSTRAINT id_uniq UNIQUE(id);

CREATE TABLE business_license_loc (
  business_license_info_id integer,
  lat float8,
  lon float8,
  earth_pos earth,
  CONSTRAINT fk1_child FOREIGN KEY (business_license_info_id)
      REFERENCES business_license_info (id) ON UPDATE CASCADE ON DELETE CASCADE
);

Useful OpenRefine function:
'http://nominatim.openstreetmap.org/search?format=json&q=' + escape(value, 'url')

select info.*, earth_distance(earth_pos, ll_to_earth(36.165659999999995, -115.14115720000001)) * 0.000621371192  AS dist_mi from business_license_loc loc JOIN business_license_info info ON info.id = loc.business_license_info_id  where lat <> 0 order by dist_mi asc LIMIT 20;