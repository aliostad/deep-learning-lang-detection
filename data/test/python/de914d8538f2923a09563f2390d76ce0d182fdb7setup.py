from setuptools import setup, find_packages


setup(
    name='django-app-manage',
    version='0.9',
    description='Manage.py for Django Apps',
    url='https://github.com/ojii/django-app-manage',
    author='Jonas Obrist',
    author_email='ojiidotch@gmail.com',
    license='BSD',
    classifiers=[
        'Development Status :: 4 - Beta',
        'Intended Audience :: Developers',
        'Topic :: Software Development :: Build Tools',
        'License :: OSI Approved :: BSD License',
        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.3',
        'Programming Language :: Python :: 3.4',
    ],
    packages=find_packages(exclude=['test_app', 'docs', 'manage', 'tests']),
    install_requires=[
        'Django',
        'dj-database-url',
    ],
)
