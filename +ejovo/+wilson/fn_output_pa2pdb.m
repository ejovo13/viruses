function [class_pa] = fn_output_pa2pdb(paN3,qz,pdbid,prefix,digs)
%% qz = 22
% pa = Mvpa(qz).vpa_au; [x,N] = size(pa);
R = max(calc_radii(paN3));
%
if exist('digs') == 0
    digs = 3;
end
[N,x] = size(paN3); 

ICO = fn_load_ICO(); w1 = ICO(1,:)';
DOD = fn_load_DOD(); v1 = DOD(1,:)'; v2 = DOD(2,:)';
IDD = fn_load_IDD(); u1 = IDD(1,:)';

class_pa = [];
% pae = point array element or individual point from a point array.
n52 = cross(w1,u1); t52 = w1/norm(w1);
n53 = cross(w1,v1); t53 = v1/norm(v1);
n23 = cross(u1,v1); t23 = u1/norm(u1);
n53a = cross(w1,v2); t53a = v2/norm(v2);

label_pa_au = strcat(pdbid,'_',prefix,'_',num2str(qz),'.pdb');
fid1 = fopen(label_pa_au,'w');    

for mm = 1:N
    pae =  paN3(mm,:)'/R;
    test5 = round(dot(pae,w1)/(norm(pae)*norm(w1)),digs);
    test3 = round(dot(pae,v1)/(norm(pae)*norm(v1)),digs);
    test3a = round(dot(pae,v2)/(norm(pae)*norm(v2)),digs);
    test2 = round(dot(pae,u1)/(norm(pae)*norm(u1)),digs);
    p52 = round(dot(pae-t52,n52),digs);
    p53 = round(dot(pae-t53,n53),digs);
    p53a = round(dot(pae-t53a,n53a),digs);
    p23 = round(dot(pae-t23,n23),digs);
    if test5 == 1
        class_pa(mm) = 5;
        fprintf(fid1,'ATOM      1  5   ALA    1     % 8.3f% 8.3f%8.3f  1.00  1.00      M1\n', [paN3(mm,1)'; paN3(mm,2)'; paN3(mm,3)';]);
    elseif test3 == 1
        class_pa(mm) = 3;
        fprintf(fid1,'ATOM      1  3   ALA    1     % 8.3f% 8.3f%8.3f  1.00  1.00      M1\n', [paN3(mm,1)'; paN3(mm,2)'; paN3(mm,3)';]);
    elseif test3a == 1
        class_pa(mm) = 3;
        fprintf(fid1,'ATOM      1  3   ALA    1     % 8.3f% 8.3f%8.3f  1.00  1.00      M1\n', [paN3(mm,1)'; paN3(mm,2)'; paN3(mm,3)';]);
    elseif test2 == 1
        class_pa(mm) = 2;
        fprintf(fid1,'ATOM      1  2   ALA    1     % 8.3f% 8.3f%8.3f  1.00  1.00      M1\n', [paN3(mm,1)'; paN3(mm,2)'; paN3(mm,3)';]);
    elseif p52 == 0
        class_pa(mm) = 52;
        fprintf(fid1,'ATOM      1  52  ALA    1     % 8.3f% 8.3f%8.3f  1.00  1.00      M1\n', [paN3(mm,1)'; paN3(mm,2)'; paN3(mm,3)';]);
    elseif p53 == 0
        class_pa(mm) = 53;
        fprintf(fid1,'ATOM      1  53  ALA    1     % 8.3f% 8.3f%8.3f  1.00  1.00      M1\n', [paN3(mm,1)'; paN3(mm,2)'; paN3(mm,3)';]);
    elseif p53a == 0
        class_pa(mm) = 53;
        fprintf(fid1,'ATOM      1  53  ALA    1     % 8.3f% 8.3f%8.3f  1.00  1.00      M1\n', [paN3(mm,1)'; paN3(mm,2)'; paN3(mm,3)';]);
    elseif p23 == 0
        class_pa(mm) = 23;
        fprintf(fid1,'ATOM      1  23  ALA    1     % 8.3f% 8.3f%8.3f  1.00  1.00      M1\n', [paN3(mm,1)'; paN3(mm,2)'; paN3(mm,3)';]);
    else
        class_pa(mm) = 99;     
        fprintf(fid1,'ATOM      1  99  ALA    1     % 8.3f% 8.3f%8.3f  1.00  1.00      M1\n', [paN3(mm,1)'; paN3(mm,2)'; paN3(mm,3)';]);
        %[test5,test3,test2,p52,p53,p53a,p23]
    end
end
fclose(fid1);

%%
figure
plot3d(paN3/R,'*')
hold on
fn_add2plot_auvol(1.2)
plot3(t52(1),t52(2),t52(3),'rp')
plot3(t53(1),t53(2),t53(3),'gv')
plot3(t53a(1),t53a(2),t53a(3),'kv')
plot3(t23(1),t23(2),t23(3),'bd')
% plot3d(w1,'rp')
% plot3d(v1,'gs')
% plot3d(v2,'go')
% plot3d(u1,'bd')
axis equal
class_pa