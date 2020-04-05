# pls-work

## Tools Setup

- Vagrant https://www.vagrantup.com/docs/installation/.
- Virtualbox https://www.virtualbox.org/.
- make

## Development

To setup your dev cluster run:

```bash
# Can be run in parallel.
make master
make node
```

After that Polyaxon console should be accessible in on http://localhost:8080.
Credentials are `root/rootpassword`.

To clean your dev cluster run:

```bash
make clean
```
