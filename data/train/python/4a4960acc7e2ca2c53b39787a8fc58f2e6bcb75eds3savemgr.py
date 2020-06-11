import os
import shutil


class DS3SaveMgr:

    def __init__(self, game_save_loc, game_save_file, save_repo_loc):
        self.game_save_loc = game_save_loc
        self.game_save_file = game_save_file
        self.save_repo_loc = save_repo_loc

    def backup(self, backup_subdir='backup', game_save_must_exist=True):
        backup_dir = os.path.join(self.save_repo_loc, backup_subdir)
        self.create_dir(backup_dir)

        backup_counter = 0
        backup_file = self.generate_backup_file(backup_counter)

        existing_backup_files = os.listdir(backup_dir)
        while backup_file in existing_backup_files:
            backup_counter += 1
            backup_file = self.generate_backup_file(backup_counter)

        game_save_path = os.path.join(self.game_save_loc, self.game_save_file)
        backup_path = os.path.join(backup_dir, backup_file)

        self.validate_file(game_save_path, game_save_must_exist)
        if os.path.exists(game_save_path) and os.path.isfile(game_save_path):
            print('Backing up file \'{}\' to \'{}\'...'.format(game_save_path, backup_path))
            shutil.copyfile(game_save_path, backup_path)

    def restore(self):
        self.backup('replaced', False)

        backup_dir = os.path.join(self.save_repo_loc, 'backup')
        save_name, save_ext = os.path.splitext(self.game_save_file)
        existing_backup_files = os.listdir(backup_dir)
        for backup_file in reversed(existing_backup_files):
            if save_name in backup_file and save_ext in backup_file:
                break

        backup_path = os.path.join(backup_dir, backup_file)
        self.validate_file(backup_path, True)

        game_save_path = os.path.join(self.game_save_loc, self.game_save_file)
        self.create_dir(self.game_save_loc)

        print('Restoring file \'{}\' to \'{}\'...'.format(backup_path, game_save_path))
        shutil.copyfile(backup_path, game_save_path)

    def generate_backup_file(self, counter):
        save_name, save_ext = os.path.splitext(self.game_save_file)
        return '{}_{}{}'.format(save_name, str(counter).zfill(3), save_ext)

    @staticmethod
    def create_dir(_dir):
        if os.path.isfile(_dir):
            print('ERROR: Path \'{}\' is not a directory.'.format(_dir))
            exit(1)

        if not os.path.exists(_dir):
            try:
                os.mkdir(_dir)
            except Exception as e:
                print('ERROR: Unable to create directory \'{}\' - {}'.format(_dir, e))
                exit(1)

    @staticmethod
    def validate_file(path, must_exist=True):
        if not must_exist:
            return

        if not os.path.exists(path):
            print('ERROR: File \'{}\' doesn\'t exist!'.format(path))
            exit(1)

        if not os.path.isfile(path):
            print('ERROR: File \'{}\' is not a file!'.format(path))
            exit(1)
