function hull = InitialHull(pnts,dims)
    global n_dec_c;
    global bugreport;
    global hull_ids;
    hull = {};                
    %all possible combinations of #dims sets of points 
    combs = nchoosek(1:size(pnts,2),length(dims));
    
    for i=1:length(combs)
        v = pnts(:,combs(i,:));
        [h,h0] = GetHyperplane(v,dims);
        if HPinChull(h,h0,v,hull,dims,1) || HPinChull(-h,-h0,v,hull,dims,1)
            continue
        end
        ec = h*pnts(:,setdiff(1:size(pnts,2), combs(i,:)));
        if round(min(ec),n_dec_c) >= round(h0,n_dec_c) 
            hull = [hull, {hull_ids; {-h,-h0}; v;1}];
            hull_ids = hull_ids + 1;
        else
            hull = [hull, {hull_ids; {h,h0}; v;1}];
            hull_ids = hull_ids + 1;
        end
    end
    
    %remove hyperplanes laying inside the chull 
    to_remove = [];
    for j=1:size(hull,2) 
       ec = round(hull{2,j}{1}*pnts,n_dec_c);
       h0 = round(hull{2,j}{2},n_dec_c);
       if min(ec) < h0 && max(ec) > h0
            to_remove = [to_remove j];
            if bugreport == 1
                disp('HP removed in inital hull.\n')
            end
       end
    end
    hull(:,to_remove) = [];
end
