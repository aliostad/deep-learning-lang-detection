--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: metpetdb
--

COPY auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add permission	1	add_permission
2	Can change permission	1	change_permission
3	Can delete permission	1	delete_permission
4	Can add group	2	add_group
5	Can change group	2	change_group
6	Can delete group	2	delete_group
7	Can add user	3	add_user
8	Can change user	3	change_user
9	Can delete user	3	delete_user
10	Can add content type	4	add_contenttype
11	Can change content type	4	change_contenttype
12	Can delete content type	4	delete_contenttype
13	Can add session	5	add_session
14	Can change session	5	change_session
15	Can delete session	5	delete_session
16	Can add site	6	add_site
17	Can change site	6	change_site
18	Can delete site	6	delete_site
19	Can add log entry	7	add_logentry
20	Can change log entry	7	change_logentry
21	Can delete log entry	7	delete_logentry
22	Can add api access	8	add_apiaccess
23	Can change api access	8	change_apiaccess
24	Can delete api access	8	delete_apiaccess
25	Can add api key	9	add_apikey
26	Can change api key	9	change_apikey
27	Can delete api key	9	delete_apikey
28	Can add group extra	10	add_groupextra
29	Can change group extra	10	change_groupextra
30	Can delete group extra	10	delete_groupextra
31	Can add group access	11	add_groupaccess
32	Can change group access	11	change_groupaccess
33	Can delete group access	11	delete_groupaccess
34	Can add geometry column	12	add_geometrycolumn
35	Can change geometry column	12	change_geometrycolumn
36	Can delete geometry column	12	delete_geometrycolumn
37	Can add user	13	add_user
38	Can change user	13	change_user
39	Can delete user	13	delete_user
40	Can add users role	14	add_usersrole
41	Can change users role	14	change_usersrole
42	Can delete users role	14	delete_usersrole
43	Can add image type	15	add_imagetype
44	Can change image type	15	change_imagetype
45	Can delete image type	15	delete_imagetype
46	Can add georeference	16	add_georeference
47	Can change georeference	16	change_georeference
48	Can delete georeference	16	delete_georeference
49	Can add image format	17	add_imageformat
50	Can change image format	17	change_imageformat
51	Can delete image format	17	delete_imageformat
52	Can add metamorphic grade	18	add_metamorphicgrade
53	Can change metamorphic grade	18	change_metamorphicgrade
54	Can delete metamorphic grade	18	delete_metamorphicgrade
55	Can add metamorphic region	19	add_metamorphicregion
56	Can change metamorphic region	19	change_metamorphicregion
57	Can delete metamorphic region	19	delete_metamorphicregion
58	Can add mineral type	20	add_mineraltype
59	Can change mineral type	20	change_mineraltype
60	Can delete mineral type	20	delete_mineraltype
61	Can add mineral	21	add_mineral
62	Can change mineral	21	change_mineral
63	Can delete mineral	21	delete_mineral
64	Can add reference	22	add_reference
65	Can change reference	22	change_reference
66	Can delete reference	22	delete_reference
67	Can add region	23	add_region
68	Can change region	23	change_region
69	Can delete region	23	delete_region
70	Can add rock type	24	add_rocktype
71	Can change rock type	24	change_rocktype
72	Can delete rock type	24	delete_rocktype
73	Can add role	25	add_role
74	Can change role	25	change_role
75	Can delete role	25	delete_role
76	Can add spatial ref sys	26	add_spatialrefsys
77	Can change spatial ref sys	26	change_spatialrefsys
78	Can delete spatial ref sys	26	delete_spatialrefsys
79	Can add subsample type	27	add_subsampletype
80	Can change subsample type	27	change_subsampletype
81	Can delete subsample type	27	delete_subsampletype
82	Can add admin user	28	add_adminuser
83	Can change admin user	28	change_adminuser
84	Can delete admin user	28	delete_adminuser
85	Can add element	29	add_element
86	Can change element	29	change_element
87	Can delete element	29	delete_element
88	Can add element mineral type	30	add_elementmineraltype
89	Can change element mineral type	30	change_elementmineraltype
90	Can delete element mineral type	30	delete_elementmineraltype
91	Can add image reference	31	add_imagereference
92	Can change image reference	31	change_imagereference
93	Can delete image reference	31	delete_imagereference
94	Can add oxide	32	add_oxide
95	Can change oxide	32	change_oxide
96	Can delete oxide	32	delete_oxide
97	Can add oxide mineral type	33	add_oxidemineraltype
98	Can change oxide mineral type	33	change_oxidemineraltype
99	Can delete oxide mineral type	33	delete_oxidemineraltype
100	Can add project	34	add_project
101	Can change project	34	change_project
102	Can delete project	34	delete_project
103	Can add sample	35	add_sample
104	Can change sample	35	change_sample
105	Can delete sample	35	delete_sample
106	Can read sample	35	read_sample
107	Can add sample metamorphic grade	36	add_samplemetamorphicgrade
108	Can change sample metamorphic grade	36	change_samplemetamorphicgrade
109	Can delete sample metamorphic grade	36	delete_samplemetamorphicgrade
110	Can add sample metamorphic region	37	add_samplemetamorphicregion
111	Can change sample metamorphic region	37	change_samplemetamorphicregion
112	Can delete sample metamorphic region	37	delete_samplemetamorphicregion
113	Can add sample mineral	38	add_samplemineral
114	Can change sample mineral	38	change_samplemineral
115	Can delete sample mineral	38	delete_samplemineral
116	Can add sample reference	39	add_samplereference
117	Can change sample reference	39	change_samplereference
118	Can delete sample reference	39	delete_samplereference
119	Can add sample region	40	add_sampleregion
120	Can change sample region	40	change_sampleregion
121	Can delete sample region	40	delete_sampleregion
122	Can add sample aliase	41	add_samplealiase
123	Can change sample aliase	41	change_samplealiase
124	Can delete sample aliase	41	delete_samplealiase
125	Can add subsample	42	add_subsample
126	Can change subsample	42	change_subsample
127	Can delete subsample	42	delete_subsample
128	Can add grid	43	add_grid
129	Can change grid	43	change_grid
130	Can delete grid	43	delete_grid
131	Can add chemical analyses	44	add_chemicalanalyses
132	Can change chemical analyses	44	change_chemicalanalyses
133	Can delete chemical analyses	44	delete_chemicalanalyses
134	Can add chemical analysis element	45	add_chemicalanalysiselement
135	Can change chemical analysis element	45	change_chemicalanalysiselement
136	Can delete chemical analysis element	45	delete_chemicalanalysiselement
137	Can add chemical analysis oxide	46	add_chemicalanalysisoxide
138	Can change chemical analysis oxide	46	change_chemicalanalysisoxide
139	Can delete chemical analysis oxide	46	delete_chemicalanalysisoxide
140	Can add image	47	add_image
141	Can change image	47	change_image
142	Can delete image	47	delete_image
143	Can read image	47	read_image
144	Can add image comment	48	add_imagecomment
145	Can change image comment	48	change_imagecomment
146	Can delete image comment	48	delete_imagecomment
147	Can add image on grid	49	add_imageongrid
148	Can change image on grid	49	change_imageongrid
149	Can delete image on grid	49	delete_imageongrid
150	Can add project invite	50	add_projectinvite
151	Can change project invite	50	change_projectinvite
152	Can delete project invite	50	delete_projectinvite
153	Can add project member	51	add_projectmember
154	Can change project member	51	change_projectmember
155	Can delete project member	51	delete_projectmember
156	Can add project sample	52	add_projectsample
157	Can change project sample	52	change_projectsample
158	Can delete project sample	52	delete_projectsample
159	Can add sample comment	53	add_samplecomment
160	Can change sample comment	53	change_samplecomment
161	Can delete sample comment	53	delete_samplecomment
162	Can add uploaded file	54	add_uploadedfile
163	Can change uploaded file	54	change_uploadedfile
164	Can delete uploaded file	54	delete_uploadedfile
165	Can add xray image	55	add_xrayimage
166	Can change xray image	55	change_xrayimage
167	Can delete xray image	55	delete_xrayimage
168	Can read user	13	read_user
169	Can read image type	15	read_imagetype
170	Can read metamorphic grade	18	read_metamorphicgrade
171	Can read metamorphic region	19	read_metamorphicregion
172	Can read mineral type	20	read_mineraltype
173	Can read mineral	21	read_mineral
174	Can read reference	22	read_reference
175	Can read region	23	read_region
176	Can read rock type	24	read_rocktype
177	Can read subsample type	27	read_subsampletype
178	Can read element	29	read_element
179	Can read element mineral type	30	read_elementmineraltype
180	Can read image reference	31	read_imagereference
181	Can read oxide	32	read_oxide
182	Can read oxide mineral type	33	read_oxidemineraltype
183	Can read sample metamorphic grade	36	read_samplemetamorphicgrade
184	Can read sample metamorphic region	37	read_samplemetamorphicregion
185	Can read sample mineral	38	read_samplemineral
186	Can read sample reference	39	read_samplereference
187	Can read sample region	40	read_sampleregion
188	Can read sample aliase	41	read_samplealiase
189	Can read subsample	42	read_subsample
190	Can read grid	43	read_grid
191	Can read chemical analyses	44	read_chemicalanalyses
192	Can read chemical analyses element	45	read_chemicalanalyseselement
193	Can read chemical analyses oxide	46	read_chemicalanalysesoxide
194	Can read image comment	48	read_imagecomment
195	Can read sample comment	53	read_samplecomment
\.


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: metpetdb
--

SELECT pg_catalog.setval('auth_permission_id_seq', 167, true);


--
-- PostgreSQL database dump complete
--

