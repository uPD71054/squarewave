function ret = genWave03(f0, t, mktable, tablesize, bandLimit)
    // arguments *********************************************************/
    //f0            note frequency
    //t             time
    //mktable       make or load table.dat flag(0:false, otherwise:true)
    //table_size    size of table
    //band_limit    addition upper limit of fourier series
    /******************************************************************************/

    // make or load wave lookup-tabel
    if (dir("table.dat").name(1)=="table.dat") & (mktable ~= 0)
        disp("load table.dat");
        load("table.dat", "table");
    else
        //disp("make tabel.dat");
        table = zeros(1,table_size);
        for i = 1:2:floor(bandLimit)
            table = table + sin(2 * %pi * i * (0:length(table)-1) / table_size) / i;
        end
        table = 0.5 * table / max(table);
        save("table.dat", "table");
    end
    // generate wave data
    phase = pmodulo(table_size * f0 * t, table_size);
    ret = interp1(0:(table_size - 1), table, phase, "linear", 0);
endfunction
