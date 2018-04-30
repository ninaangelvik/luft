class WeatherData < ActiveRecord::Base
	AREAS = { 
	"Tromsø" 	=> [69.680, 18.95],
    "Bodø" 		=> [67.28, 14.405],
    "Narvik"      => [68.438, 17.427],
    "Alta"        => [69.971, 23.303],
    "Nord-Troms"  => [69.929, 20.999],
    "Harstad"     => [68.798, 16.541],
    "Lakselv"     => [70.051, 24.971],
    "Mo i Rana"   => [66.313, 14.142]
	}

    acts_as_mappable :default_units => :kms,
                    :lat_column_name => :latitude,
                    :lng_column_name => :longitude


end
