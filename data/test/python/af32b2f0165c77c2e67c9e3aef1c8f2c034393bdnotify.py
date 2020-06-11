import logging

L = logging.getLogger('notify')

import os

from config import conf

import db

def url(*a):
    return 'http://{}/{}'.format(
        conf.web.server.name,
        '/'.join(str(x) for x in a)
        )

def shorten(s):
    return url('-', db.shorten(s))

def notify_weechat(buf, msg):
    if not buf:
        return

    weechat = str(conf.notify.weechat.dir)

    if not os.path.exists(weechat):
        L.warn('weechat instance missing, cannot notify')
        return

    cmd = '{} */say {}\n'.format(buf, msg)

    count = 0
    for fname in os.listdir(weechat):
        if not fname.startswith('weechat_fifo_'):
            continue

        count += 1
        try:
            with open(os.path.join(weechat, fname), 'a') as f:
                f.write(cmd)
        except:
            L.warn('swallowing failure when writing to %s', fname, exc_info=True)

    if count == 0:
        L.warn('could not find any fifos for %s', buf)

def notify_github_push(repository, obj):
    notify_weechat(
        repository.notify,
        '\2\x0306{}\x03 pushed {} commit{} to \x0306{}/{}\x03: {}'.format(
            obj['pusher']['name'],
            len(obj['commits']),
            '' if len(obj['commits']) == 1 else 's',
            obj['repository']['name'],
            obj['ref'].split('/')[-1],
            shorten(obj['compare']),
            )
        )

    if len(obj['commits']) <= 6:
        printed = obj['commits']
    else:
        printed = obj['commits'][:4]

    for commit in printed:
        notify_weechat(
            repository.notify,
            '\x0f  \2\x0306{}\x03\2\x0f: {}'.format(
                commit['id'][:8],
                commit['message'].split('\n')[0],
                )
            )
    if len(printed) != len(obj['commits']):
        notify_weechat(
            repository.notify,
            '\x0f  and \2\x0306{}\3\2\x0f more...'.format(
                len(obj['commits']) - len(printed)
                )
            )

def notify_github_watch(repository, obj):
    notify_weechat(
        repository.notify,
        '\2\x0306{}\3\2 starred \2\x0306{}\3\2'.format(
            obj['sender']['login'],
            obj['repository']['name']
            )
        )

def notify_github_pull_request_review_comment(repository, obj):
    notify_weechat(
        repository.notify,
        '\2\x0306{}\3\2 commented on \2\x0306{}\3\2 pull request #{} \2{}\2: {}'.format(
            obj['comment']['user']['login'],
            obj['repository']['name'],
            obj['pull_request']['number'],
            obj['pull_request']['title'],
            shorten(obj['comment']['html_url']),
            )
        )

def notify_github_pull_request(repository, obj):
    notify_weechat(
        repository.notify,
        '\2\x0306{}\3\2 {} \2\x0306{}\3\2 pull request #{} \2{}\2: {}'.format(
            obj['sender']['login'],
            obj['action'],
            obj['repository']['name'],
            obj['pull_request']['number'],
            obj['pull_request']['title'],
            shorten(obj['pull_request']['html_url']),
            )
        )

def notify_github_page_build(repository, obj):
    pass

def notify_github_member(repository, obj):
    notify_weechat(
        repository.notify,
        '\2\x0306{}\3\2 {} to \2\x0306{}\3\2 by \2\x0306{}\3\2'.format(
            obj['member']['login'],
            obj['action'],
            obj['repository']['name'],
            obj['sender']['login'],
            )
        )

def notify_github_issues(repository, obj):
    label_part = ''
    if len(obj['issue']['labels']) > 0:
        label_part = ' [\x0306{}\3\x0f]'.format(
            '\3\x0f, \x0306'.join(x['name'] for x in obj['issue']['labels'])
            )
    notify_weechat(
        repository.notify,
        '\2\x0306{}\3\2 {} \2\x0306{}\3\2 issue #{} \2{}\2{}: {}'.format(
            obj['sender']['login'],
            obj['action'],
            obj['repository']['name'],
            obj['issue']['number'],
            obj['issue']['title'],
            label_part,
            shorten(obj['issue']['html_url']),
            )
        )

def notify_github_issue_comment(repository, obj):
    notify_weechat(
        repository.notify,
        '\2\x0306{}\3\2 commented on \2\x0306{}\3\2 issue #{} \2{}\2: {}'.format(
            obj['sender']['login'],
            obj['repository']['name'],
            obj['issue']['number'],
            obj['issue']['title'],
            shorten(obj['comment']['html_url']),
            )
        )

def notify_github_fork(repository, obj):
    notify_weechat(
        repository.notify,
        '\2\x0306{}\3\2 forked \2\x0306{}\3\2: {}'.format(
            obj['sender']['login'],
            obj['repository']['name'],
            shorten(obj['forkee']['html_url']),
            )
        )

def notify_github_commit_comment(repository, obj):
    notify_weechat(
        repository.notify,
        '\2\x0306{}\3\2 commented on commit \2\x0306{}\3\2: {}'.format(
            obj['sender']['login'],
            obj['comment']['commit_id'][:8],
            shorten(obj['comment']['html_url']),
            )
        )

def notify_github(event, repository, obj):
    if not bool(int(conf.notify.github)):
        return
    if not repository.notify:
        return

    if event == 'push':
        notify_github_push(repository, obj)
    if event == 'watch':
        notify_github_watch(repository, obj)
    if event == 'pull_request_review_comment':
        notify_github_pull_request_review_comment(repository, obj)
    if event == 'pull_request':
        notify_github_pull_request(repository, obj)
    if event == 'page_build':
        notify_github_page_build(repository, obj)
    if event == 'member':
        notify_github_member(repository, obj)
    if event == 'issues':
        notify_github_issues(repository, obj)
    if event == 'issue_comment':
        notify_github_issue_comment(repository, obj)
    if event == 'fork':
        notify_github_fork(repository, obj)
    if event == 'commit_comment':
        notify_github_commit_comment(repository, obj)
