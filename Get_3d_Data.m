function [c,phi,al]=Get_3d_Data()
[FileNames,PathName,~] = uigetfile('../../C_Progs/2d_CSD/cmake-build-debug/*.txt','Select One or More Files', ...
    'MultiSelect', 'on');
f=fopen(strcat(PathName,FileNames{1}));
% f=fopen('/Users/Austin/Documents/MATLAB/2d_csd/test.txt');
header=textscan(f,'%d,%d,%d,%d,%d',1);
fclose(f);
[Nx,Ny,Nt,Nc,Ni]=header{1:5};
Nz = length(FileNames);
c=zeros(Nx,Ny,Nz,Nc,Ni,Nt);
phi=zeros(Nx,Ny,Nz,Nc,Nt);
al=zeros(Nx,Ny,Nz,Nc-1,Nt);

for z=1:Nz
    A=dlmread(strcat(PathName,FileNames{z}),',',1,0);
    if(Nc==0 && Ni==0)
        one_var = true;
        Ni=1;
        Nc=1;
    else
        one_var= false;
    end
    
    if(one_var)
        ind=1;
        for t=1:Nt
            for j=1:Ni
                for i=1:Nc
                    c(:,:,z,i,j,t)=reshape(A(ind,:),Nx,Ny);
                    ind=ind+1;
                end
            end
            
            for j=1:Nc
                phi(:,:,z,j,t)=c(:,:,i,j,t);
            end
            for j=1:Nc-1
                al(:,:,z,j,t)=c(:,:,i,j,t);
            end
        end
    else
        ind=1;
        for t=1:Nt
            for j=1:Ni
                for i=1:Nc
                    c(:,:,z,i,j,t)=reshape(A(ind,:),Nx,Ny);
                    ind=ind+1;
                end
            end
            
            for j=1:Nc
                phi(:,:,z,j,t)=reshape(A(ind,:),Nx,Ny);
                ind=ind+1;
            end
            for j=1:Nc-1
                al(:,:,z,j,t)=reshape(A(ind,:),Nx,Ny);
                ind=ind+1;
            end
        end
    end
end

