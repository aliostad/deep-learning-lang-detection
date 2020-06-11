#!/bin/bash

# Note: You should run this script twice.  The first pass just caches the data analysis portions for faster re-runs.

./../process_radpat_plots.py --yaml rad_plot_combined.yaml

./../process_radpat_plots.py --yaml rad_plot_head_combined.yaml
./../process_radpat_plots.py --yaml rad_plot_head_datacap.yaml
./../process_radpat_plots.py --yaml rad_plot_head_datacap2.yaml


./../process_radpat_plots.py --yaml rad_plot_shoulder_left_combined.yaml
./../process_radpat_plots.py --yaml rad_plot_shoulder_left_datacap.yaml
./../process_radpat_plots.py --yaml rad_plot_shoulder_left_datacap2.yaml

./../process_radpat_plots.py --yaml rad_plot_shoulder_right_combined.yaml
./../process_radpat_plots.py --yaml rad_plot_shoulder_right_datacap.yaml
./../process_radpat_plots.py --yaml rad_plot_shoulder_right_datacap2.yaml


./../process_radpat_plots.py --yaml rad_plot_orange_head.yaml
