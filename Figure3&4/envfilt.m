function envelope=envfilt(ts,f0,fs)

L=length(ts);
vert=size(ts,2)>size(ts,1);

if vert
    ts=ts';
end



inc=find(~isnan(ts));
ts=interp1(inc,ts(inc),(1:L)');

W=round(fs/f0);
smoothWindow=normpdf(0:(2*W),W,W/(3*sqrt(2*log(2))))';

odd=mod(W,2);
if odd
    e=(1/2)*(imerode(ts,ones(W,1))+imdilate(ts,ones(W,1)));

else
    e=(1/2)*(imerode(ts,ones(W,1))+imdilate(ts,ones(W,1)));
    e=(1/2)*(e(1:end-1)+e(2:end));
    e=interp1((2:L)'-1/2,e,(1:L)','linear','extrap');

end

if vert
    envelope=conv(e,smoothWindow,'same')';
else
    envelope=conv(e,smoothWindow,'same');
end
