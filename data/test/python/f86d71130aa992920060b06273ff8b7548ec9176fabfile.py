from fabric.api import local

def test():
	local('./manage.py test business', capture=False)
	local('./manage.py test common', capture=False)
	local('./manage.py test ecommerce', capture=False)
	local('./manage.py test invoices', capture=False)
	local('./manage.py test orders', capture=False)
	local('./manage.py test party', capture=False)
	local('./manage.py test products', capture=False)

def package():
	local('tar -cv --exclude-vcs --exclude build --exclude-backups -f /tmp/bizondemand.tgz .', capture=False)

def prepare_deploy():
	test()
	package()
