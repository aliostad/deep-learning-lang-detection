def diff_commits(repository, commit, from_commit=None):
    tree = commit.tree
    from_tree = from_commit.tree if from_commit else None
    if from_tree:
        diff = repository.diff(from_tree, tree)
    else:
        diff = tree.diff_to_tree(swap=True)
    return diff


def diff_commit(repository, commit):
    parents = commit.parents
    if len(parents) == 1:
        diff = diff_commits(repository, commit, parents[0])
    elif len(parents) == 2:
        merge_base_hex = repository.merge_base(parents[0].hex, parents[-1].hex)
        merge_base = repository[merge_base_hex] if merge_base_hex else commit
        diff = diff_commits(repository, parents[-1], merge_base)
    elif len(parents) > 2:
        diff = diff_commits(repository, commit, parents[0])
    else:
        diff = diff_commits(repository, commit)
    return diff