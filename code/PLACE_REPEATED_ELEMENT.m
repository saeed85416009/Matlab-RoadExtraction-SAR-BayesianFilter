function index = PLACE_REPEATED_ELEMENT(A)
[n, bin] = histc(A, unique(A));
multiple = find(n > 1);
index    = find(ismember(bin, multiple));
