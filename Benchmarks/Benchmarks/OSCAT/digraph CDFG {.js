digraph CDFG {
    node [shape=box];
    
    SCHEDULE;
    ADD;
    CAST;
    PARAM;
    FUNCCALL;
    
    SCHEDULE -> ADD;
    ADD -> CAST;
    CAST -> PARAM;
    PARAM -> FUNCCALL;
    
    ADD [label="ADD\nOp1: DIR, INT32, VAR, START\nOp2: DIR, INT16, LIT, START\nRes: DIR, INT32, VAR, START"];
    CAST [label="CAST\nOp1: DIR, INT32, VAR, START\nRes: DIR, FLOAT, TMP, START"];
    PARAM [label="PARAM\nOp1: DIR, FLOAT, TMP, START"];
    FUNCCALL [label="FUNCCALL\nOp1: DIR, FLOAT, FUNC, START\nRes: DIR, FLOAT, VAR, START"];
}
