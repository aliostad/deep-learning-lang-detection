from tool_shed.base.twilltestcase import ShedTwillTestCase, common, os
import logging

log = logging.getLogger(__name__)

repository_name = 'filtering_1470'
repository_description = "Galaxy's filtering tool"
repository_long_description = "Long description of Galaxy's filtering tool"

category_name = 'Test 1470 - Updating Installed Repositories'
category_description = 'Functional test suite to ensure that updating installed repositories does not create white ghosts.'

'''
1. Install a repository into Galaxy.
2. In the Tool Shed, update the repository from Step 1.
3. In Galaxy, get updates to the repository.
4. In Galaxy, uninstall the repository.
5. In Galaxy, reinstall the repository.
6. Make sure step 5 created no white ghosts.
'''


class TestUpdateInstalledRepository( ShedTwillTestCase ):
    '''Verify that the code correctly handles updating an installed repository, then uninstalling and reinstalling.'''
    
    def test_0000_initiate_users( self ):
        """Create necessary user accounts."""
        self.logout()
        self.login( email=common.test_user_1_email, username=common.test_user_1_name )
        test_user_1 = self.test_db_util.get_user( common.test_user_1_email )
        assert test_user_1 is not None, 'Problem retrieving user with email %s from the database' % test_user_1_email
        test_user_1_private_role = self.test_db_util.get_private_role( test_user_1 )
        self.logout()
        self.login( email=common.admin_email, username=common.admin_username )
        admin_user = self.test_db_util.get_user( common.admin_email )
        assert admin_user is not None, 'Problem retrieving user with email %s from the database' % admin_email
        admin_user_private_role = self.test_db_util.get_private_role( admin_user )
        
    def test_0005_create_filtering_repository( self ):
        """Create and populate the filtering_0530 repository."""
        category = self.create_category( name=category_name, description=category_description )
        self.logout()
        self.login( email=common.test_user_1_email, username=common.test_user_1_name )
        repository = self.get_or_create_repository( name=repository_name, 
                                                    description=repository_description, 
                                                    long_description=repository_long_description, 
                                                    owner=common.test_user_1_name,
                                                    category_id=self.security.encode_id( category.id ), 
                                                    strings_displayed=[] )
        self.upload_file( repository, 
                          filename='filtering/filtering_1.1.0.tar',
                          filepath=None,
                          valid_tools_only=True,
                          uncompress_file=True,
                          remove_repo_files_not_in_tar=False, 
                          commit_message='Uploaded filtering 1.1.0 tarball.',
                          strings_displayed=[], 
                          strings_not_displayed=[] )
        
    def test_0010_install_filtering_to_galaxy( self ):
        '''Install the filtering_1470 repository to galaxy.'''
        '''
        This is step 1 - Install a repository into Galaxy.
        '''
        self.galaxy_logout()
        self.galaxy_login( email=common.admin_email, username=common.admin_username )
        self.install_repository( repository_name, 
                                 common.test_user_1_name, 
                                 category_name, 
                                 install_tool_dependencies=False,
                                 install_repository_dependencies=False,
                                 new_tool_panel_section_label='Filtering' )
        installed_repository = self.test_db_util.get_installed_repository_by_name_owner( repository_name, 
                                                                                         common.test_user_1_name )
        strings_displayed = [ 'filtering_1470',
                              self.url.replace( 'http://', '' ), 
                              installed_repository.installed_changeset_revision,
                              installed_repository.changeset_revision ]
        self.display_galaxy_browse_repositories_page( strings_displayed=strings_displayed )
        self.display_installed_repository_manage_page( installed_repository, 
                                                       strings_displayed=strings_displayed )
        
    def test_0015_update_repository( self ):
        '''Upload a readme file to the filtering_1470 repository.'''
        '''
        This is step 2 - In the Tool Shed, update the repository from Step 1.
        
        Importantly, this update should *not* create a new installable changeset revision, because that would
        eliminate the process we're testing in this script. So, we upload a readme file.
        '''
        repository = self.test_db_util.get_repository_by_name_and_owner( repository_name, common.test_user_1_name )
        self.upload_file( repository, 
                          filename='filtering/readme.txt',
                          filepath=None,
                          valid_tools_only=True,
                          uncompress_file=False,
                          remove_repo_files_not_in_tar=False, 
                          commit_message='Uploaded readme.',
                          strings_displayed=[], 
                          strings_not_displayed=[] )
       
    def test_0020_get_repository_updates( self ):
        '''Get updates to the installed repository.'''
        '''
        This is step 3 - In Galaxy, get updates to the repository.
        '''
        installed_repository = self.test_db_util.get_installed_repository_by_name_owner( repository_name, 
                                                                                         common.test_user_1_name )
        self.update_installed_repository( installed_repository )
        
    def test_0025_uninstall_repository( self ):
        '''Uninstall the filtering_1470 repository.'''
        '''
        This is step 4 - In Galaxy, uninstall the repository.
        '''
        installed_repository = self.test_db_util.get_installed_repository_by_name_owner( repository_name, 
                                                                                         common.test_user_1_name )
        self.uninstall_repository( installed_repository )

    def test_0030_reinstall_repository( self ):
        '''Reinstall the filtering_1470 repository.'''
        '''
        This is step 5 - In Galaxy, reinstall the repository.
        '''
        installed_repository = self.test_db_util.get_installed_repository_by_name_owner( repository_name, 
                                                                                         common.test_user_1_name )
        self.reinstall_repository( installed_repository )
    
    def test_0035_verify_absence_of_ghosts( self ):
        '''Check the count of repositories in the database named filtering_1470 and owned by user1.'''
        '''
        This is step 6 - Make sure step 5 created no white ghosts.
        '''
        installed_repository = self.test_db_util.get_installed_repository_by_name_owner( repository_name, 
                                                                                         common.test_user_1_name,
                                                                                         return_multiple=True )
        assert len( installed_repository ) == 1, 'Multiple filtering repositories found in the Galaxy database, possibly indicating a "white ghost" scenario.'
        
