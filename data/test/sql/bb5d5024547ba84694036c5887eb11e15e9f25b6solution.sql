/* Based on problems given in http://cs.nyu.edu/faculty/davise/ai/bayesnet.html */

/*1.  P(D) */
SELECT SUM(a.p*d.p*b.p) FROM a, d, b WHERE  d.a=a.a AND d.b=b.b AND d.d='t';

/*2.  P(D=F, C=T) */
SELECT SUM(a.p*c.p*d.p*b.p) FROM a, c, d, b WHERE c.a=a.a AND d.a=a.a AND d.b=b.b AND c.c='t' AND d.d='f';

/*3.  P(A=T | C=T) */
DROP VIEW IF EXISTS temp_view; 
CREATE VIEW temp_view as SELECT a.a as a, SUM(a.p*c.p) as probability FROM a, c WHERE c.a=a.a AND c.c='t' GROUP BY a.a;
SELECT a, probability/(SELECT SUM(probability) FROM temp_view) FROM temp_view WHERE a='t';

/*4. P(A=T | D=F) */
DROP VIEW IF EXISTS temp_view; 
CREATE VIEW temp_view as SELECT a.a as a, SUM(a.p*b.p*d.p) as probability FROM a, b, d WHERE d.a=a.a AND d.b=b.b AND d.d='f' GROUP BY a.a;
SELECT a, probability/(SELECT SUM(probability) FROM temp_view) FROM temp_view WHERE a='t';

/*5. P(A=T,D=T | B=F) */
DROP VIEW IF EXISTS temp_view; 
CREATE VIEW temp_view as SELECT a.a as a, d.d as d, SUM(a.p*b.p*d.p) as probability FROM a, b, d WHERE d.a=a.a AND d.b=b.b AND b.b='f' GROUP BY a.a, d.d;
SELECT a, d, probability/(SELECT SUM(probability) FROM temp_view) FROM temp_view WHERE a='t' AND d='t';

/* 6 P(C=T | A=F, E=T) */
DROP VIEW IF EXISTS temp_view; 
CREATE VIEW temp_view as SELECT c.c as c, SUM(a.p*c.p*e.p) as probability FROM a, c, e WHERE c.a=a.a AND e.c=c.c AND a.a='f' AND e.e='t' GROUP BY c.c;
SELECT c, probability/(SELECT SUM(probability) FROM temp_view) FROM temp_view WHERE c='t';

