import tryCommand

tryCommand.tryCmd("py manage.py makemigrations --settings=debug.settings");
tryCommand.tryCmd("python manage.py makemigrations --settings=debug.settings");
tryCommand.tryCmd("py ../manage.py makemigrations --settings=debug.settings");
tryCommand.tryCmd("python ../manage.py makemigrations --settings=debug.settings");
if tryCommand.isSuccess() == False:
    exit("[ERROR] Previous Command Failed, Exit");
tryCommand.restart();
tryCommand.tryCmd("py manage.py migrate --settings=debug.settings");
tryCommand.tryCmd("python manage.py migrate --settings=debug.settings");
tryCommand.tryCmd("py ../manage.py migrate --settings=debug.settings");
tryCommand.tryCmd("python ../manage.py migrate --settings=debug.settings");
tryCommand.pause();
