gfm = read_float_binary('gamma_max_fm.bin', 100000);
sfm = read_float_binary('std_dev_fm.bin', 100000);

gam = read_float_binary('gamma_max_am.bin', 100000);
sam = read_float_binary('std_dev_am.bin', 100000);

scatter(gfm,ones(size(gfm)));
hold on
scatter(gam,ones(size(gam)),'r');
