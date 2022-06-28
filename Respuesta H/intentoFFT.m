% 'f' contiene las frecuencias discretas (SUPONGO). tmp'
X = EEG.data;
X = detrend(X')';
tmp   = fft(X, [], 2);
f     = linspace(0, EEG.srate/2, floor(size(tmp,2)/2));
f     = f(2:end); % remove DC (match the output of PSD)
tmp   = tmp(:,2:floor(size(tmp,2)/2),:);
try
    X = bsxfun(@times, X, hamming(size(X,2))'); % apply hamming window even for data trials (not the case in EEGLAB 13)
catch
    X = bsxfun(@times, X, hamming2(size(X,2))');
end

% Si quiero poder
Xpower     = tmp.*conj(tmp);

% si no quiero poder
X = tmp;

find(f>= 10 & f<= 11)
plot(f, Xpower(9,:))
mean(Xpower(9,find(f>= 10 & f< 11)))



% if strcmpi(g.output, 'power')
%     X     = tmp.*conj(tmp);
%     if strcmpi(g.logtrials, 'on'),  X = 10*log10(X); end
% else
%     X = tmp;
%     datatype = 'SPECTRUMFFT';
% end