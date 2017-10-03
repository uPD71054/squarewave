function ret = genWave04(f, t, mktable, tablesize)
    // arguments *********************************************************/
    //f0            note frequency
    //t             time
    //mktable       make or load table.dat flag(0:false, otherwise:true)
    //table_size    size of table
    //band_limit    addition upper limit of fourier series
    /******************************************************************************/
    // const **********************************************************************/
    oct = 8;
    notes = 12;
    f0 = 27.5;
    /******************************************************************************/

    // make or load wave lookup-tabel
    if (dir("table2.dat").name(1)=="table2.dat") & (mktable ~= 0)
        //disp("load table2.dat");
        load("table2.dat", "table");
    else
        disp("make tabel2.dat");
        table = zeros(oct * notes, tablesize);
        for j = 1:oct * notes
            freq = f0 * 2^((j-1)/12)
            for i = 1:2:floor((fs/2)/freq)
                table(j,:) = table(j,:) + sin(2 * %pi * i * (0:tablesize-1) / tablesize) / i;
            end
            table(j,:) = 0.5 * table(j,:) / max(table(j,:));
        end
        save("table2.dat", "table");
    end

    // generate wave data
    phase = pmodulo(table_size * f * t, table_size);
    ret = interp1(0:(tablesize - 1), table(floor(12*(log2(f)-log2(f0)) + 0.5) + 1,:), phase, "linear", 0);    
endfunction
