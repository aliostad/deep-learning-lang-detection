#xml to csv
python data_file_converter.py  --in-file sample_files/project__xml_sample_data.xml \
                               --out-file xml_converted_to_csv.csv \
                               --in-format-file sample_files/project__xml_schema.xsd \
                               --out-format-file sample_files/project__csv_format.txt \
                               --in-format-type xml \
                               --out-format-type csv \
                               --config-file sample_files/config.yaml


# csv to xml
python data_file_converter.py  --in-file sample_files/project__csv_sample_data.txt \
                               --out-file csv_converted_to_xml.xml \
                               --in-format-file sample_files/project__csv_format.txt \
                               --out-format-file sample_files/project__xml_schema.xsd \
                               --in-format-type csv \
                               --out-format-type xml \
                               --config-file sample_files/config.yaml
