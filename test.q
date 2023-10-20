args:{d:.Q.opt[.z.x];:$[not x in key d;0b;raze d x]}

build_test_data:{[db]
    tbl:2 cut (`$":",db,"/TAQ";`trade`quote;`$":",db,"/REF";`sec_master`corp_actions`calendar); 
    make_dbs .' tbl;
 };

make_dbs:{[db;t] dt:2024.01.01+til 30; make_db[db] .' (dt cross t) }

make_db:{[db;dt;t]
    sym_name:`$"sym_",last "/"vs string db;
    (0N!`$("/" sv string (db;dt;t)),"/") set .Q.ens[db;;sym_name] ([] a:1 2 3; b:`a`b`c)
 };

main:{
    -1 "Generating table in ",args`source;
    commands:build_test_data[args`source];
 };

main[];