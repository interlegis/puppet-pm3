# init.pp
# requires https://github.com/interlegis/puppet-resource-looping.git

class pm3 ( $dbinstances = {}, 
          ) {

validate_hash ($dbinstances)
create_resources ( "pm3::dbinstance", $dbinstances )

}
