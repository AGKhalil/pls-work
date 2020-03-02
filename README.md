# pls-work

## Tools Setup

- Vagrant https://www.vagrantup.com/docs/installation/.
- Virtualbox https://www.virtualbox.org/.
- make

## Development

To setup your dev cluster run:

```
make setup
```

Then ssh with:

```
vagrant ssh
```

Go to /vagrant/script directory and run install_*.sh scripts in order.

To delete your dev cluster run:

```
make clean
```
