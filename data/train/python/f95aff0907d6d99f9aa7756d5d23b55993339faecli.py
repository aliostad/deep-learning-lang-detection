#!/usr/bin/env python
# coding: utf-8

import argparse
import os
import sys

import pyquality


path_join = os.path.join

def main():
    parser = argparse.ArgumentParser(description=pyquality.__doc__)
    parser.add_argument('repository', help='Path or URL to the Git repository')
    args = parser.parse_args()

    repository = args.repository
    repository_path = repository
    if not os.path.exists(repository):
        repository_path = os.path.basename(repository).replace('.git', '')
        pyquality.git_clone(repository, repository_path)
    else:
        repository_path = os.path.normpath(repository_path)
    repository_name = os.path.basename(repository_path)

    results_path = path_join(os.path.curdir,
                             'results-{}'.format(repository_name))
    # TODO: be able to change results path
    if not os.path.exists(results_path):
        os.mkdir(results_path)

    tags_filename = path_join(results_path, repository_name + '-tags.csv')
    ratios_filename = path_join(results_path, repository_name + '-pep8-{}.csv')
    pyquality.analyse_repository(repository_path, tags_filename,
                                 ratios_filename)

    graph_filename = path_join(results_path, repository_name + '-{}.png')
    pyquality.plot_graphs(repository_name, tags_filename, ratios_filename,
                          graph_filename)

    video_filename = path_join(results_path, repository_name) + '.ogv'
    pyquality.render_project_history(repository_name, video_filename,
                                     tags_filename, results_path)

    report_filename = path_join(results_path, repository_name + '-report.html')
    pyquality.render_report(repository_name, tags_filename,
                            ratios_filename, video_filename,
                            pyquality.default_template, report_filename)


if __name__ == '__main__':
    main()
