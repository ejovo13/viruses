function hunt(vector, collection)

 
reducedCollection = collection - vector;
a = abs(reducedCollection) < [0.05;0.05;0.05];
column = [];
for m = 1:length(a)
    if a(1,m) == 1 && a(2,m) == 1 && a(3,m) == 1
        column = [column, m]
        
    end   
end

