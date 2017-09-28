require 'httparty'
desc "Generate backup of database"
task backup: :environment do
	token = "ya29.GlvRBKN_2tAdXmimVXYl6iQDOXJ_Esm72saE7wuTo84FQO9duPfy2mNpfQAeMDemJgxYYwKse1bjStCWdwKd-Wjhhk3dUtNV8jbilwSHYIpUNJtuSACMXuv11e5T"
	auth = "Bearer " + token
  res = HTTParty.post("https://www.googleapis.com/sql/v1beta4/projects/masteroppgave-177911/instances/luftprosjekt/export",
  				:headers => {"Authorization" => auth},
  				:body => {
					  "exportContext": {
					    "kind": "sql#exportContext",
					    "fileType": "SQL",
					    "uri": "gs://masteroppgave-177911/Cloud_SQL_Export_#{Time.now.strftime "%Y_%m_%d"}",
					  }
					}
					
					)
  pp res
end
