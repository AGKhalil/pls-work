setup:
	vagrant up --provider=virtualbox

clean:
	vagrant destroy --force
