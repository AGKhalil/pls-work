master:
	vagrant up --provider=virtualbox alpha
	vagrant ssh alpha -c '/vagrant/script/plswork master'
	vagrant ssh alpha -c '/vagrant/script/plswork polyaxon'

node:
	vagrant up --provider=virtualbox zeta
	vagrant ssh zeta -c '/vagrant/script/plswork node'

clean:
	vagrant destroy --force
