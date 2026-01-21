* Encoding: UTF-8.
title 'Chapter 11 Analysis Example: Logistic Mediation Model'.

* The following program code reads in the dataset and computes the
  analysis for the logistic mediation model example in Chapter 11.

* Four variables are defined: (a) obs, i.e., observation number, 
  (b) X, i.e., the amount of grilled meat in hundreds of grams
  eaten during a typical week, (c) M, i.e., the amount of fatty
  acids in the blood, and (d) Y, i.e., pancreatic cancer, where 
  1 codes the presence of pancreatic cancer and 0 codes
  the absence of pancreatic cancer.

data  list free
 / obs x  m  y .
begin data
1	0	4	1
2	0	3	0
3	0	4	1
4	0	4	0
5	0	4	1
6	0	4	0
7	0	3	1
8	0	2	0
9	0	5	1
10	0	3	0
11	0	2	0
12	0	4	0
13	1	4	1
14	0	3	0
15	1	4	1
16	1	5	1
17	0	5	0
18	0	4	1
19	0	3	0
20	1	6	1
21	0	6	1
22	0	3	0
23	1	5	1
24	0	3	0
25	1	3	1
26	1	4	1
27	1	4	1
28	0	3	0
29	0	4	0
30	0	3	1
31	0	3	0
32	0	3	0
33	0	4	1
34	0	4	1
35	0	3	0
36	0	4	1
37	0	4	0
38	1	4	0
39	1	3	0
40	0	7	1
41	0	1	0
42	1	5	1
43	0	4	1
44	0	4	0
45	0	4	1
46	1	4	1
47	0	4	0
48	0	2	0
49	0	2	0
50	0	5	0
51	0	4	1
52	0	3	0
53	1	3	0
54	1	4	1
55	0	5	0
56	0	3	0
57	0	3	0
58	0	3	0
59	0	4	1
60	1	4	1
61	1	5	1
62	0	3	0
63	0	5	1
64	0	5	1
65	1	5	1
66	0	6	0
67	0	4	0
68	0	2	0
69	1	4	0
70	0	3	0
71	0	3	0
72	0	5	1
73	0	3	0
74	1	5	1
75	0	3	0
76	1	5	1
77	0	5	1
78	0	5	1
79	0	5	0
80	1	4	1
81	0	4	0
82	0	6	1
83	0	5	0
84	0	4	1
85	0	3	0
86	0	4	0
87	0	4	1
88	1	5	1
89	1	6	1
90	0	2	0
91	1	5	1
92	0	4	1
93	0	5	1
94	0	3	0
95	0	2	0
96	0	4	1
97	0	3	0
98	0	6	1
99	0	4	1
100	0	4	0
101	0	5	1
102	0	5	1
103	0	4	0
104	0	3	0
105	0	5	0
106	0	4	1
107	0	3	0
108	0	4	0
109	1	4	1
110	1	4	1
111	1	4	0
112	1	6	1
113	1	5	1
114	1	4	1
115	0	5	0
116	0	4	1
117	0	4	1
118	0	3	0
119	0	3	0
120	0	3	0
121	0	4	1
122	0	4	0
123	0	4	0
124	0	5	1
125	0	2	0
126	1	5	1
127	1	4	1
128	0	4	1
129	1	5	1
130	0	5	1
131	0	4	0
132	0	3	0
133	0	3	0
134	0	2	0
135	0	4	0
136	0	4	0
137	0	3	0
138	0	3	0
139	0	5	1
140	1	7	1
141	0	3	0
142	0	4	0
143	0	4	0
144	0	5	1
145	1	4	1
146	0	3	0
147	0	3	0
148	0	4	0
149	0	6	1
150	0	3	0
151	0	5	1
152	1	4	0
153	0	3	0
154	0	4	1
155	0	5	1
156	0	4	0
157	1	6	1
158	0	3	0
159	0	4	1
160	1	4	0
161	0	3	0
162	0	4	0
163	1	3	0
164	0	4	1
165	0	3	0
166	0	4	1
167	1	3	0
168	0	5	0
169	0	4	0
170	1	4	1
171	0	6	1
172	0	3	0
173	1	3	0
174	1	3	0
175	0	5	1
176	0	5	1
177	0	5	1
178	0	3	0
179	1	4	0
180	0	4	0
181	0	4	1
182	0	4	0
183	0	5	0
184	0	4	0
185	0	5	0
186	1	5	1
187	0	2	0
188	1	4	1
189	0	5	1
190	0	4	1
191	0	5	1
192	0	3	0
193	0	4	0
194	1	3	1
195	1	4	1
196	0	4	0
197	0	5	1
198	0	3	1
199	0	5	1
200	0	5	1
end data.


* The following commands run a logistic regression model for the variables
   defined above: (a) X, (b) M, and (c) Y.

* NOTE: The regression of M on X is conducted in OLS regression as the
  mediator is a continuous variable.

* STEP 1:
	Regress the outcome on the independent variable. That is, regress
            pancreatic cancer on the amount of grilled meat eaten in a typical week.

logistic regression variables= y
  with x.
execute.

* STEP 2:
	Regress the outcome on the independent and mediating variables.
           *That is, regress pancreatic cancer on the amount of grilled meat
            eaten in a typical week and the amount of fatty acids in the blood.

logistic regression variables=y
  with x m.
execute.

* STEP 3:
	Regress the mediator on the independent variable. 
           *That is, regress the amount of fatty acids in the blood on the amount
            of grilled meat eaten in a typical week.

regression
 /dependent=m
 /enter=x.
 execute.
