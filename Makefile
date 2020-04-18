master:
	vagrant up --provider=virtualbox alpha
	vagrant ssh alpha -c 'PLSWORK_KUBELET_EVICTIONHARD_NODEFSAVAILABLE=200Mi /vagrant/script/plswork master'
	vagrant ssh alpha -c '/vagrant/script/plswork polyaxon'

node:
	vagrant up --provider=virtualbox zeta
	vagrant ssh zeta -c 'PLSWORK_KUBELET_EVICTIONHARD_NODEFSAVAILABLE=200Mi /vagrant/script/plswork node'

clean:
	vagrant destroy --force
