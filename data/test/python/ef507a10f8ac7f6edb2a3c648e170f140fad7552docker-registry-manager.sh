#!/usr/bin/env python2

from __future__ import print_function
import json, sys, requests

print(sys.version)

docker_registry_url = 'http://example.com:5000'
catalog_url = docker_registry_url + '/v2/_catalog'
tag_url = docker_registry_url + '/v2/<REPOSITORY>/tags/list'
manifest_url = docker_registry_url + '/v2/<REPOSITORY>/manifests/<TAG>'
delete_fslayer_url = docker_registry_url + '/v2/<REPOSITORY>/blobs/<FSLAYER>'
delete_tag_url = docker_registry_url + '/v2/<REPOSITORY>/manifests/<DIGEST>'

r = requests.get(catalog_url)
catalog = r.json()

repositories = {}

for repository in catalog['repositories']:
    url = tag_url.replace('<REPOSITORY>', repository)
    r = requests.get(url)
    repository = r.json()
    tags = repository['tags']
    repository = repository['name']
    repositories[repository] = {}

    if tags is not None:
        for tag in tags:
            url = manifest_url.replace('<REPOSITORY>', repository)
            url = url.replace('<TAG>', tag)
            r = requests.get(url)
            docker_content_digest = r.headers['Docker-Content-Digest']
            repositories[repository][tag] = {'Docker-Content-Digest': docker_content_digest, 'layerDigests': []}
            manifest = r.json()

            for fslayer in manifest['fsLayers']:
                repositories[repository][tag]['layerDigests'].append(fslayer['blobSum'])

def print_menu(repositories):
    for repository_name, repository in repositories.iteritems():
        length = len(repository_name) + 2;
        print(repository_name + ': ', end='')

        first_line = True
        for tag_name, tag in repository.iteritems():
            fs_layers_count = str(len(tag['layerDigests']))
            if first_line:
                print(tag_name + ' (' + fs_layers_count + ')')
                first_line = False
            else:
                print(" "*length + tag_name + ' (' + fs_layers_count + ')')

        print()

def delete_image(repositories, repository, tag):
    for fslayer in reversed(repositories[repository][tag]['layerDigests']):
        url = delete_fslayer_url.replace('<REPOSITORY>', repository)
        url = url.replace('<FSLAYER>', fslayer)
        r = requests.delete(url)
        print(r)

    url = delete_tag_url.replace('<REPOSITORY>', repository)
    url = url.replace('<DIGEST>', repositories[repository][tag]['Docker-Content-Digest'])
    r = requests.delete(url)
    print(r)

print_menu(repositories)
repository = raw_input('Enter a repository to delete: ')
tag = raw_input('Enter a tag to delete: ')

print('Deleting ' + repository + ':' + tag)
delete_image(repositories, repository, tag)
