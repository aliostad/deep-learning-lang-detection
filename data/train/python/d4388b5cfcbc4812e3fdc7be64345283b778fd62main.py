#!/usr/bin/env python3
import sys
import os
from github3 import GitHub
import re

if len(sys.argv) < 2:
	print("Usage:")
	print("\t%s https://github.com/{username}/{repository}" % (sys.argv[0],))
	sys.exit(1)


github_url = sys.argv[1]

match = re.search("github.com/([^/]+)/([^/]+)$", github_url)
if match == None:
	print("error: Bad GitHub URL: `%s`" % (github_url,))
	sys.exit(1)

username, repository = match.groups()
repository = repository.rstrip('.git')
repository_url = "https://github.com/%s/%s" % (username, repository)

print("Cloning issues from repository `%s`..." % (repository_url))


gh = GitHub()
rep = gh.repository(username, repository)
issues = rep.iter_issues(state='all')


os.mkdir(repository)

for i in issues:
	with open(os.path.join(repository, 'issue#%d' % (i.number,)), 'w') as f:
		f.write('%s:\n' % (i.user,))
		f.write(i.body)
		f.write('\n')
		for c in i.iter_comments():
			f.write('\n---\n')
			f.write('%s:\n' % (c.user,))
			f.write(c.body)
			f.write('\n')

