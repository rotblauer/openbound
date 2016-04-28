# accepts env (ie instance) as necessary argument, ie <staging> or <production>
ssstop(){
	local env=$1
	command cd /mnt/rstacks-"$env"/current && RAILS_ENV="$env" bundle exec sunspot-solr stop --port=8983 --data-directory=/mnt/rstacks-"$env"/shared/solr/data --pid-dir=/mnt/rstacks-"$env"/shared/pids
}

ssstart(){
	local env=$1
	command cd /mnt/rstacks-"$env"/current && RAILS_ENV="$env" bundle exec sunspot-solr start --port=8983 --data-directory=/mnt/rstacks-"$env"/shared/solr/data --pid-dir=/mnt/rstacks-"$env"/shared/pids
}

ssreindex(){
	local env=$1
	command cd /mnt/rstacks-"$env"/current && RAILS_ENV="$env" bundle exec rake sunspot:solr:reindex
}