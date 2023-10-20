args:{d:.Q.opt[.z.x];:$[not x in key d;0b;raze d x]}

ln:{[source;db;dt;t]"ln -sfn ",source,"/",db,"/",dt,"/",t," ",dt}

generate_commands:{[source;dest]
    dtree:get `$":",source;
    parts:string key[dtree]!key@'get dtree;

    syms:{`$x where x like "sym*"}@'parts;
    dates:{("D"$x) except 0Nd}@'parts;
    tbls:key@'dtree@'key dtree;

    mkdirs:("mkdir -p ",)@'string distinct raze get dates;

    ln_syms:("ln -sfn ",(source,"/"),"/" sv)@'string flip (key syms;raze get syms);
    ln_tbls:ln[source] .' string raze key[tbls],''(cross/)@'flip (get[dates];get[tbls]);
    
    :raze (("mkdir -p ";"cd "),\:dest;mkdirs;ln_syms;ln_tbls);
 };

main:{
    -1 "Scanning ",args`source;
    commands:generate_commands[args`source;args`dest];

    `:generate.sh 0: commands;
    -1 "Saved commands to create vdbs in 'generate.sh'";

    if[1~"J"$args`exec;
        system"bash -x generate.sh";
        -1 "Done!";
        :(::);
    ];
    -1 "In dry run mode, add '-exec 1' parameter to execute commands.";
 };

main[];