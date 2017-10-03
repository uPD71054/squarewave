function ret = genWave02(f0, t, multiple, fc, q)
    // arguments *********************************************************/
    fs = 44100/* Hz */; // sampling rate
    //f0                frequecncy
    //t                 time
    //multiple          44.1kHz * multiple oversampling
    //fc                cut off frequency
    //q                 q-value
    /******************************************************************************/

    // calcurate filter parameters
    omega = 2.0 * %pi *  fc / (fs * multiple);
    alpha = sin(omega) / (2.0 * q);
    a0 =  1.0 + alpha;
    a1 = -2.0 * cos(omega);
    a2 =  1.0 - alpha;
    b0 = (1.0 - cos(omega)) / 2.0;
    b1 =  1.0 - cos(omega);
    b2 = (1.0 - cos(omega)) / 2.0;

    // generate wave data
    t = 0 : fs - 1;
    t0 = 0 : fs * multiple - 1;
    y0 = 0.5 * squarewave(2.0 * %pi * f0 * t0 / (fs * multiple));
    // filtering
    y = zeros(length(t0));
    y(1) = y0(1);
    y(2) = y0(2);
    for i = 3:length(t0);
        y(i) = b0/a0 * y0(i) + b1/a0 * y0(i - 1)  + b2/a0 * y0(i - 2) - a1/a0 * y(i - 1) - a2/a0 * y(i - 2);
    end
    // decimation
    ret = y(1:multiple:$);
endfunction
